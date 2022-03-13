library(readr)
library(dplyr)
library(tibble)
library(purrr)

source("load.R")

# Load, sort, and re-save list of known duplicates (which we've categorized, see `cleaning/duplicates/README.md`):
categorized_duplicates <- read_csv("cleaning/duplicates/categorized.csv") %>%
  arrange(reason, owner_org)

categorized_duplicates %>%
  write_csv("cleaning/duplicates/categorized.csv")

# Identify duplicates (based on `owner_org` and `request_number` combo)
uncategorized_duplicates <- saved_summaries %>%
  group_by(owner_org, request_number) %>%
  summarize(count = n()) %>%
  filter(count > 1) %>%
  anti_join(categorized_duplicates)

count_duplicates_by_field <- function(x, field_to_count) {
  x %>%
    select(owner_org, request_number, !!field_to_count) %>%
    distinct() %>%
    group_by(owner_org, request_number) %>%
    summarize(count = n()) %>%
    filter(count > 1) %>%
    anti_join(categorized_duplicates) %>%
    nrow()
}

duplicates_by_field <- saved_summaries %>%
  colnames() %>%
  .[!. %in% c("owner_org", "request_number")] %>% # remove the two columns we don't want to include when counting duplicates (because they're our unique ID columns, we hope)
  enframe(name = NULL, value = "field") %>%
  mutate(
    count_duplicates = map_int(field, ~ saved_summaries %>% count_duplicates_by_field(.x))
  )

duplicates_by_field %>%
  write_csv("cleaning/duplicates/summary-by-field.csv")

saved_summaries %>%
  semi_join(uncategorized_duplicates) %>%
  arrange(owner_org, request_number) %>%
  select(owner_org, request_number, everything()) %>%
  write_csv("cleaning/duplicates/uncategorized.csv")
