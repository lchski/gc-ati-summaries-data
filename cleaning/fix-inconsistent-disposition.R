source("load.R")
source("cleaning/duplicates/identify.R")

duplicates_due_to_disposition <- saved_summaries %>%
  identify_duplicates_by_field("disposition")

# See remaining non-standard dispositions
saved_summaries %>%
  filter(! disposition %in% c("DP (Disclosed in part / Communication partielle)",
                              "DA (All disclosed / Communication totale)",
                              "NE (No records exist / Aucun document n’existe)",
                              "EX (All exempted / Exception totale)",
                              "EC (All excluded / Exclusion totale)",
                              "AB (Request abandoned / Demande abandonnée)",
                              "TR (Transferred / Demande transmise)")) %>% # remove known-good codes
  group_by(disposition) %>%
  summarize(count = n()) %>%
  arrange(-count)

saved_summaries %>%
  semi_join(duplicates_due_to_disposition) %>%
  arrange(owner_org, request_number) %>%
  View()

# TODO:
# - one has a standard disposition, the other is.na (drop the latter)
# - one has a standard disposition, the other a non-standard (drop the latter)
