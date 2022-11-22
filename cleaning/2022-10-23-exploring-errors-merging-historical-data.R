library(ggplot2)
library(forcats)
library(lubridate)

updated_summaries <-read_csv('ati-summaries.csv')

#It seems that overwriting the old summaries by merging the historical summaries with the published summaries fixes the disposition error issue
table(updated_summaries$disposition)

#When I run distinct on these updated summaries limited to request number and owner org, we lose 254 duplicated entries.
updated_summaries2 <- updated_summaries %>% 
  distinct(request_number, owner_org, .keep_all = TRUE)

#At first glance, these 254 duplicated entries seem to be related to each other. The differences are mostly in how the summaries are worded from what I can tell.
dups <-  anti_join(updated_summaries, updated_summaries2)

#over 200 of these duplicates belong to shared services
dups %>% 
  ggplot(aes(x = fct_infreq(owner_org)))+
  geom_bar()+
  theme(axis.text.x = element_text(angle = 90))

## The large majority of these duplicates are from the past 2 years. This indicates to me that there is a difference between the published data and the historical data. Could be fixed by deciding that the published data sets are the authoritative record. Could also just keep them as the discrepancies are potentially interesting to system stakeholders.
dups %>% 
  ggplot(aes(as.factor(year)))+
  geom_bar()
  

