source("cleaning/load.R")

# Helper variables / files for finding duplicates due to encoding
duplicate_requests_due_to_summary_en <- saved_summaries %>%
  select(owner_org, request_number, summary_en) %>%
  distinct() %>%
  group_by(owner_org, request_number) %>%
  summarize(count = n()) %>%
  filter(count > 1) %>%
  anti_join(known_duplicates)
