library(tidyverse)

summary_col_types <- cols(
  year = col_double(),
  month = col_double(),
  request_number = col_character(),
  summary_en = col_character(),
  summary_fr = col_character(),
  disposition = col_character(),
  pages = col_double(),
  comments_en = col_character(),
  comments_fr = col_character(),
  umd_number = col_double(),
  owner_org = col_character(),
  owner_org_title = col_character()
)

saved_summaries <- read_csv(
  "ati-summaries.csv",
  col_types = summary_col_types
)

published_summaries <- read_csv(
  "https://open.canada.ca/data/dataset/0797e893-751e-4695-8229-a5066e4fe43c/resource/19383ca2-b01a-487d-88f7-e1ffbc7d39c2/download/ati.csv",
  col_types = summary_col_types
)

updated_summaries <- bind_rows(saved_summaries, published_summaries) %>% # Combine existing and new summaries.
  distinct() %>% # Remove duplicate entries.
  arrange(year, month, owner_org, request_number) ## Sort so updates are easier to see and diffs more consistent.

updated_summaries %>% write_csv("ati-summaries.csv")
