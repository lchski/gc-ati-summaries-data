source("cleaning/load.R")

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
