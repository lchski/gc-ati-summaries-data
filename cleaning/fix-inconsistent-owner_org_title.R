source("load.R")
source("cleaning/duplicates/identify.R")

duplicates_due_to_owner_org_title <- saved_summaries %>%
  identify_duplicates_by_field("owner_org_title")

saved_summaries %>%
  mutate(
    owner_org_title = case_when(
      owner_org_title == fixed("Department of Justice | Ministère de la Justice") ~ "Department of Justice Canada | Ministère de la Justice Canada",
      TRUE ~ owner_org_title
    )
  ) %>%
  distinct() %>%
  write_csv("ati-summaries.csv")
