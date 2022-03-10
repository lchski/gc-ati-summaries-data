source("cleaning/load.R")

signals_for_disposition_code <- function(disposition_code) {
  signals_for_code <- standard_disposition_code_signals %>%
    filter(standard_disposition_code == disposition_code)
  
  if (nrow(signals_for_code) == 0) {
    return(FALSE)
  }
  
  signals_for_code %>%
    pull(signals) %>%
    .[[1]] %>% # extract character vector from nested list
    paste0(collapse = "|")
}

standard_disposition_code_signals <- tribble(
  ~standard_disposition_code, ~signals,
  "DP", c(
    "^DP \\(Disclosed in part / Communication partielle\\)$",
    "^dp",
    "^disclosed in part",
    "^a-p - disclosed in part",
    "^divulgation partielle",
    "^partial disclosure",
    "^communication partielle",
    "^a-p - communication partielle",
    "^partial",
    "^disclose in part",
    "^partiel disclosure",
    "^dislcosed in part",
    "^disclosd in part",
    "communication partielle$",
    "^disclosed ar part",
    "^disclosed re part",
    "^disclosure in part",
    "^in part$",
    "disclosed in part$"
  ),
  "DA", c(
    "^DA \\(All disclosed / Communication totale\\)$",
    "^da",
    "^all disclosed",
    "^full release",
    "^a-p - all disclosed",
    "^divulgation complète",
    "^disclosed in full",
    "^disclosed entirely",
    "^communication totale",
    "^a-p - communication totale",
    "^fully disclosed",
    "^all discl",
    "^full discl",
    "^all released",
    "^all dislcosed",
    "^full$",
    "^disclosed all$",
    "^complete$",
    "^all diclosed",
    "^all dislosed",
    "^all records released",
    "^disclose entirely",
    "^divulgation totale",
    "^entirely disclosed",
    "^full /plein$",
    "^full/complet$",
    "divulgation totale$",
    "^records released$"
  ),
  "NE", c(
    "^NE \\(No records exist / Aucun document n’existe\\)$",
    "^ne",
    "^no records exist",
    "^does not exist",
    "^no records",
    "^no record exist",
    "^a-p - does not exist",
    "^aucun document",
    "\\(no records exist",
    "^no responsive records",
    "^does not exsist",
    "^no document exist",
    "^a-p - aucun document",
    "^records do not exist",
    "^aucune document n'existe",
    "^n'existe pas",
    "^ni records exist",
    "^nil$",
    "^nil - aucun document n' existe",
    "^no record located",
    "^no existing document",
    "^nothing disclosed \\(no records records exist",
    "^n'existes pas",
    "aucun d'aucument n'existe$",
    "aucun document$",
    "aucun document n'existe$",
    "document inexistant$",
    "aucun document existe$"
  ),
  "EX", c(
    "^EX \\(All exempted / Exception totale\\)$",
    "^ex",
    "^nothing disclosed \\(exemption\\)",
    "^all exempted",
    "^nothing disclosed \\(exemp",
    "^records exemp",
    "^nothing disclosed \\(all exemp",
    "^all exemp",
    "\\(all excluded\\)",
    "^total exemp",
    "^19\\(1\\)", # cites an exception in the Act
    "^all material exempt",
    "^subsection 19",
    "^subsection 16",
    "^withheld \\(exceptions",
    "^a-p - all exempted",
    "^all withheld",
    "^aucune information divulguée",
    "^nothing disclosed \\(exexmption",
    "^nothing disclosed, exemption",
    "\\(exemption\\)"
  ),
  "EC", c(
    "^EC \\(All excluded / Exclusion totale\\)$",
    "^ec",
    "^nothing disclosed \\(excl",
    "^all excluded",
    "^a-p - all excluded",
    "^publicly avail", # may be worth making a different code? very rare though, and technically an exclusion
    "^all exclued",
    "^entirely excluded",
    "^nothing disclosed \\(withheld\\)",
    "^nothing disclosed / exclusion totale"
  ),
  "AB", c(# Note: Not actually a standard code, but it shows up a few times in the data, and seemed worth preserving.
    "^AB \\(Request abandoned / Demande abandonnée\\)",
    "^AB \\(Request abandoned / Demande abandonnée\\)",
    "^AB \\(Request abandoned  / Demande abandonnée\\)", # typo'd a space when first implemented, heh
    "^AB \\(Request abandoned  / Demande abandonnée\\)",
    "^ab \\(request abandoned  / demande abandonnée\\)",
    "^ab \\(request abandoned / demande abandonnée\\)",
    "^aband",
    "^request abandon"
  ),
  "TR", c(# Note: Not actually a standard code, but it shows up a few times in the data, and seemed worth preserving.
    "^TR \\(Transferred / Demande transmise\\)$",
    "transferred",
    "^transfer"
  )
)

summaries_with_standardized_dispositions <- saved_summaries %>%
  mutate(disposition = str_trim(str_to_lower(disposition))) %>% # lowercase to standardize and remove some duplicates
  mutate(disposition = case_when(
    str_detect(disposition, signals_for_disposition_code("DP")) ~ "DP (Disclosed in part / Communication partielle)",
    str_detect(disposition, signals_for_disposition_code("DA")) ~ "DA (All disclosed / Communication totale)",
    str_detect(disposition, signals_for_disposition_code("NE")) ~ "NE (No records exist / Aucun document n’existe)",
    str_detect(disposition, signals_for_disposition_code("EX")) ~ "EX (All exempted / Exception totale)",
    str_detect(disposition, signals_for_disposition_code("EC")) ~ "EC (All excluded / Exclusion totale)",
    str_detect(disposition, signals_for_disposition_code("AB")) ~ "AB (Request abandoned / Demande abandonnée)",
    str_detect(disposition, signals_for_disposition_code("TR")) ~ "TR (Transferred / Demande transmise)",
    TRUE ~ disposition
  )) %>%
  distinct()

# See remaining non-standard dispositions
summaries_with_standardized_dispositions %>%
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

# Write to the CSV for the test DB.
summaries_with_standardized_dispositions %>%
  write_csv("cleaning/temp-summaries.csv")

## To override the saved set of summaries... Be sure you want to. (But don't worry too much, it's in Git!)
summaries_with_standardized_dispositions %>% write_csv("ati-summaries.csv")

