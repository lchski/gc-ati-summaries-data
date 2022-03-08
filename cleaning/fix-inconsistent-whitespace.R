source("cleaning/load.R")

squished_summaries <- saved_summaries %>%
  mutate_if(
    is.character,
    str_squish
  ) %>%
  distinct()

# Helper variables / files for finding duplicates due to whitespace
squished_summaries %>%
  semi_join(known_duplicates %>%
              filter(reason %in% c("Misc/Summary has trailing whitespace", "Misc/Summary has inconsistent internal whitespace"))) %>%
  select(owner_org, request_number, summary_fr) %>%
  distinct() %>%
  group_by(owner_org, request_number) %>%
  summarize(count = n()) %>%
  filter(count > 1)

squished_summaries %>%
  semi_join(known_duplicates %>%
              filter(reason %in% c("Misc/Summary has trailing whitespace", "Misc/Summary has inconsistent internal whitespace"))) %>%
  select(owner_org, request_number, summary_fr) %>%
  distinct() %>%
  arrange(owner_org, request_number) %>%
  write_csv("cleaning/tmp.csv")

# Write to the CSV for the test DB.
squished_summaries %>%
  write_csv("cleaning/temp-summaries.csv")

## To override the saved set of summaries... Be sure you want to. (But don't worry too much, it's in Git!)
# squished_summaries %>% write_csv("ati-summaries.csv")
