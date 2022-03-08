source("cleaning/load.R")

reencoded_summaries <- saved_summaries %>%
  mutate_if(
    is.character,
    ~ str_replace_all(., c(
      "Ã©" = "é",
      "Ã‰" = "É",
      "Ã¨" = "è",
      "â€™" = "’",
      "Ã§" = "ç",
      "Ã " = "à"
    ))
  ) %>%
  distinct()

# Write to the CSV for the test DB.
reencoded_summaries %>%
  write_csv("cleaning/temp-summaries.csv")

## To override the saved set of summaries... Be sure you want to. (But don't worry too much, it's in Git!)
# reencoded_summaries %>% write_csv("ati-summaries.csv")
