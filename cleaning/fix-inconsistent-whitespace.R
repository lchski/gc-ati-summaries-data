source("cleaning/load.R")

# Helper variables / files for finding duplicates due to whitespace
saved_summaries %>%
  semi_join(known_duplicates %>%
              filter(reason %in% c("Misc/Summary has trailing whitespace", "Misc/Summary has inconsistent internal whitespace"))) %>%
  select(owner_org, request_number, summary_fr) %>%
  distinct() %>%
  group_by(owner_org, request_number) %>%
  summarize(count = n()) %>%
  filter(count > 1)
