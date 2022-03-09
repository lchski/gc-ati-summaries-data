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

saved_summaries <- read_csv("ati-summaries.csv", col_types = summary_col_types)

known_duplicates <- read_csv("cleaning/known-duplicates.csv")

uncategorized_duplicates <- saved_summaries %>%
  group_by(owner_org, request_number) %>%
  summarize(count = n()) %>%
  filter(count > 1) %>%
  anti_join(known_duplicates)
