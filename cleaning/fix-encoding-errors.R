source("cleaning/load.R")

reencoded_summaries <- saved_summaries %>%
  mutate_if(
    is.character,
    ~ str_replace_all(., c(
      "Ã©" = "é",
      "Ã‰" = "É",
      "Ã¨" = "è",
      "â€™" = "’",
      "Ã§" = "ç",
      "Ã " = "à"
    ))
  ) %>%
  distinct()

# Helper variables / files for finding duplicates due to encoding
duplicate_requests_due_to_summary_fr <- reencoded_summaries %>%
  select(owner_org, request_number, summary_fr) %>%
  distinct() %>%
  group_by(owner_org, request_number) %>%
  summarize(count = n()) %>%
  filter(count > 1) %>%
  anti_join(known_duplicates)

duplicate_requests_due_to_summary_fr %>%
  filter(owner_org == "acoa-apeca")

reencoded_summaries %>%
  filter(owner_org == "acoa-apeca") %>%
  select(request_number, summary_fr) %>%
  distinct() %>%
  arrange(request_number) %>%
  write_csv("cleaning/tmp.csv")

# Write to the CSV for the test DB.
reencoded_summaries %>%
  write_csv("cleaning/temp-summaries.csv")

## To override the saved set of summaries... Be sure you want to. (But don't worry too much, it's in Git!)
# reencoded_summaries %>% write_csv("ati-summaries.csv")
