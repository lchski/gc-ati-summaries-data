# Full historical data is stored in the root of the repository, `ati-full-historical-data.csv`
# 
# Data we've been maintaining is also stored in the root, `ati-summaries.csv`
# 
# There's likely some overlap—but may be records missing from one or the other. Instead of
# replacing the one we've been maintaining with the historical, we'll merge them.
# 
# Then, we'll likely need to check for and eliminate duplicates. We can (hopefully!) do
# this with the existing duplicate handlers we have.

library(tidyverse)

source("lib/cleaning/encoding.R")
source("lib/cleaning/standardize-disposition.R")

# Load the existing summaries.
source("load.R")

# Load in the historical summaries.
historical_summaries <- read_csv("ati-full-historical-data.csv", col_types = summary_col_types)

# Use the same methodology from `update-ati-summaries.R` to combine the two.
combined_summaries <- bind_rows(
  historical_summaries,
  saved_summaries
) %>%
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
  arrange(year, month, owner_org, request_number)
