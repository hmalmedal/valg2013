library(dplyr, warn.conflicts = FALSE)
library(readr)

parti <- read_csv("parti.csv")

valg2013 <- read_csv("valg2013.csv", col_types = "_cc_c_i_____") %>%
  rename(Kommunestemmer = `Stemmer totalt`) %>%
  mutate(Fylke = factor(Fylke, levels = unique(Fylke))) %>%
  mutate(Kommune = factor(Kommune, levels = unique(Kommune))) %>%
  mutate(Parti = factor(Parti, levels = parti$Parti,
                        labels = parti$Partinavn)) %>%
  group_by(Kommune) %>%
  mutate(Kommunetotal = sum(Kommunestemmer)) %>%
  ungroup() %>%
  mutate(Kommuneprosent = Kommunestemmer / Kommunetotal * 100) %>%
  group_by(Fylke) %>%
  mutate(Fylkestotal = sum(Kommunestemmer)) %>%
  group_by(Fylke, Parti) %>%
  mutate(Fylkesstemmer = sum(Kommunestemmer)) %>%
  ungroup() %>%
  mutate(Fylkesprosent = Fylkesstemmer / Fylkestotal * 100) %>%
  group_by(Parti) %>%
  mutate(Landsstemmer = sum(Kommunestemmer)) %>%
  ungroup() %>%
  mutate(Landstotal = sum(Kommunestemmer),
         Landsprosent = Landsstemmer / Landstotal * 100)
