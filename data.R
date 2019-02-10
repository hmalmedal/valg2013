library(tidyverse)

parti <- read_csv("parti.csv")

valg2013 <- read_csv("valg2013.csv") %>%
  rename(Stemmer = `Stemmer totalt`) %>%
  mutate(Fylke = as_factor(Fylke)) %>%
  mutate(Kommune = as_factor(Kommune)) %>%
  mutate(Parti = factor(Parti, levels = parti$Parti,
                        labels = parti$Partinavn)) %>%
  group_by(Kommune) %>%
  mutate(Prosent = Stemmer / sum(Stemmer) * 100) %>%
  ungroup()
