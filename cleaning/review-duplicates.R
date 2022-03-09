source("cleaning/load.R")

# See various duplicate frequencies / commentary here: https://github.com/lchski/gc-ati-summaries-data/issues/3

count_duplicates_by_field <- function(x, field_to_count) {
  x %>%
    select(owner_org, request_number, !!field_to_count) %>%
    distinct() %>%
    group_by(owner_org, request_number) %>%
    summarize(count = n()) %>%
    filter(count > 1) %>%
    anti_join(known_duplicates) %>%
    nrow()
}

duplicates_by_field <- saved_summaries %>%
  colnames() %>%
  .[!. %in% c("owner_org", "request_number")] %>%
  enframe(name = NULL, value = "field") %>%
  mutate(
    count_duplicates = map_int(field, ~ saved_summaries %>% count_duplicates_by_field(.x))
  )

saved_summaries %>%
  semi_join(uncategorized_duplicates) %>%
  arrange(owner_org, request_number) %>%
  select(owner_org, request_number, everything()) %>%
  write_csv("cleaning/duplicates.csv")


