source("load.R")
source("cleaning/duplicates/identify.R")

saved_summaries %>%
  left_join(
    categorized_duplicates %>%
      filter(reason == "Misc/Missing summary for one entry but not for other")
  ) %>%
  mutate(
    meets_cleaning_criteria = case_when(
      is.na(reason) ~ TRUE, # no `reason` value present, so not included in current set of categorized duplicates—pass!
      ! is.na(summary_en) & ! is.na(summary_fr) ~ TRUE, # both summaries are set, so neither is missing (NA)—pass!
      TRUE ~ FALSE # alas, if you don't meet either above criteria, you're getting filtered out—bye!
    )
  ) %>%
  filter(meets_cleaning_criteria) %>%
  select(-reason, -meets_cleaning_criteria) %>%
  write_csv("ati-summaries.csv")
