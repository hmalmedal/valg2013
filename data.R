library(dplyr, warn.conflicts = F)

valg2013 <- read.csv("~/Documents/R/Valg 2013/valg2013.csv",
                     colClasses = c("factor",
                                    "factor",
                                    "character",
                                    "factor",
                                    "factor",
                                    "NULL",
                                    "integer",
                                    rep("NULL", 5))) %>%
  tbl_df %>%
  mutate(Fylke = factor(Fylke, unique(Fylke))) %>%
  select(FylkeID:Parti, Kommunestemmer = Stemmer.totalt)

kommunetotal <- valg2013 %>%
  group_by(KommuneID) %>%
  summarise(Kommunetotal = sum(Kommunestemmer))

valg2013 <- inner_join(valg2013, kommunetotal, by = "KommuneID") %>%
  mutate(Kommuneprosent = Kommunestemmer / Kommunetotal * 100)

fylkestotal <- valg2013 %>%
  group_by(FylkeID) %>%
  summarise(Fylkestotal = sum(Kommunestemmer))

fylkesstemmer <- valg2013 %>%
  group_by(FylkeID, Parti) %>%
  summarise(Fylkesstemmer = sum(Kommunestemmer)) %>%
  inner_join(fylkestotal, by = "FylkeID") %>%
  mutate(Fylkesprosent = Fylkesstemmer / Fylkestotal * 100)

valg2013 <- inner_join(valg2013, fylkesstemmer, by = c("FylkeID", "Parti"))

landsstemmer <- valg2013 %>%
  group_by(Parti) %>%
  summarise(Landsstemmer = sum(Kommunestemmer)) %>%
  mutate(Landstotal = sum(Landsstemmer),
         Landsprosent = Landsstemmer / Landstotal * 100)

valg2013 <- inner_join(valg2013, landsstemmer, by = "Parti")

parti <- read.csv("~/Documents/R/Valg 2013/parti.csv") %>%
  tbl_df %>%
  mutate(Partinavn = factor(Partinavn, Partinavn))

valg2013 <- valg2013 %>%
  mutate(Parti = factor(Parti, parti$Parti)) %>%
  inner_join(parti, by = "Parti")
