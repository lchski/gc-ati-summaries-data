library(tidyverse)

disp_errors <- read.csv("ati_summaries_disperr.csv")
ati_summaries_disperror <- read_csv("https://github.com/lchski/gc-ati-summaries-data/raw/main/ati-summaries.csv")

disp_errors.a <- disp_errors %>% 
  filter(is.na(pages)) %>% 
  select(request_number) %>% 
  rename(summary_en = request_number)


 ati_summaries <- ati_summaries_disperror %>% 
  filter(!summary_en %in% disp_errors.a$summary_en)


