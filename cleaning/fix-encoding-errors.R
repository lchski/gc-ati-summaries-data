source("cleaning/load.R")

reencoded_summaries <- saved_summaries %>%
  mutate_if(
    is.character,
    ~ str_replace_all(., c(
      "Ã©" = "é",
      "Ã‰" = "É",
      "Ã¨" = "è",
      "â€™" = "’",
      "â€“" = "–",
      "Ã§" = "ç",
      "Ã»" = "û",
      "Ã¢" = "â",
      "Ãª" = "ê",
      "Ã´" = "ô",
      "Â«" = "«",
      "Â»" = "»",
      "Ã " = "à",
      "Å“" = "œ",
      "Â " = " ",
      "â€¯" = " ",
      "â€‰" = " ",
      "â€œ" = "“",
      "â€" = "”",
      "Ã¡" = "á",
      "Ã®" = "î",
      "Ã¯" = "ï",
      "Ã¹" = "ù",
      "Ãˆ" = "È",
      "Ã€" = "À",
      "Ã›" = "Û",
      "Ã‡" = "Ç",
      "ÃŽ" = "Î",
      "Â·" = "·",
      "â€‘" = "‑",
      "Ã«" = "ë",
      "â€”" = "—",
      "Ãº" = "ú",
      "ÃŠ" = "Ê",
      "Â°" = "°",
      "â€¦" = "…",
      "Â\u00AD" = "-",
      "\u00AD" = "-",
      "Ã¦" = "æ",
      "Ã”" = "Ô",
      "Â®" = "®",
      "Ã‚" = "Â",
      "â€¢" = "•",
      "â€˜" = "‘",
      "Â¿" = "¿",
      "â€’" = "‒",
      "Ã±" = "ñ",
      "Ã-" = "í",
      "Ã¥" = "å",
      "Ãž" = "Þ",
      "Ã³" = "ó",
      "Ã-" = "í",
      "Âº" = "º",
      "â€’" = "‒",
      "Ã-" = "í",
      "Ã±" = "ñ",
      "âˆ’" = "−",
      "Ä±" = "ı"
    ))
  ) %>%
  distinct()

# Helper variables / files for finding duplicates due to encoding
duplicate_requests_due_to_summary_fr <- reencoded_summaries %>%
  select(owner_org, request_number, summary_fr) %>%
  distinct() %>%
  group_by(owner_org, request_number) %>%
  summarize(count = n()) %>%
  filter(count > 1) %>%
  anti_join(known_duplicates)

reencoded_summaries %>%
  semi_join(duplicate_requests_due_to_summary_fr) %>%
  select(owner_org, request_number, summary_fr) %>%
  distinct() %>%
  arrange(owner_org, request_number) %>%
  write_csv("cleaning/tmp.csv")

# Write to the CSV for the test DB.
reencoded_summaries %>%
  write_csv("cleaning/temp-summaries.csv")

## To override the saved set of summaries... Be sure you want to. (But don't worry too much, it's in Git!)
# reencoded_summaries %>% write_csv("ati-summaries.csv")
