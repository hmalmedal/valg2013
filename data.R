library(dplyr)
library(readr)

parti <- read_csv("parti.csv", col_types = "cc")

valg2013 <- read_csv("valg2013.csv", col_types = "_cc_c_i_____") %>%
  rename(Stemmer = `Stemmer totalt`) %>%
  mutate(Fylke = factor(Fylke, levels = unique(Fylke))) %>%
  mutate(Kommune = factor(Kommune, levels = unique(Kommune))) %>%
  mutate(Parti = factor(Parti, levels = parti$Parti,
                        labels = parti$Partinavn)) %>%
  group_by(Kommune) %>%
  mutate(Prosent = Stemmer / sum(Stemmer) * 100) %>%
  ungroup()
