source("load.R")
library(dplyr)

disp_errors <- read_csv("cleaning/disp_error/ati_summaries_disperr.csv")

saved_summaries <- saved_summaries %>% 
  filter(!summary_en %in% disp_errors$request_number)
