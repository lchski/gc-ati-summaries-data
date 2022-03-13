# NB: Any packages loaded here should be added to DESCRIPTION as Imports.
library(readr)
library(dplyr)
library(stringr)

# Load cleaning functions
source("lib/cleaning/encoding.R")
source("lib/cleaning/standardize-disposition.R")

# Load existing summaries
source("load.R")

published_summaries <- read_csv(
  "https://open.canada.ca/data/dataset/0797e893-751e-4695-8229-a5066e4fe43c/resource/19383ca2-b01a-487d-88f7-e1ffbc7d39c2/download/ati.csv",
  col_types = summary_col_types
)

updated_summaries <- bind_rows(saved_summaries, published_summaries) %>% # Combine existing and new summaries.
  mutate_if(
    is.character,
    ~ str_replace_all(., fixed("\r\n"), "\n") ## Convert CRLF to LF, since the ATI summaries often come from Windows machines / Excel exports.
  ) %>%
  mutate_if(
    is.character,
    str_squish
  ) %>%
  clean_summary_encoding() %>%
  standardize_summary_disposition() %>%
  distinct() %>% # Remove duplicate entries.
  arrange(year, month, owner_org, request_number) ## Sort so updates are easier to see and diffs more consistent.

updated_summaries %>% write_csv("ati-summaries.csv")
