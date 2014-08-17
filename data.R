library(plyr)
valg2013 <- read.csv("~/Documents/R/Valg 2013/valg2013.csv",
                     colClasses = c("factor",
                                    "factor",
                                    "character",
                                    "factor",
                                    "factor",
                                    "NULL",
                                    "integer",
                                    rep("NULL", 5)))
valg2013$Fylke <- factor(valg2013$Fylke, unique(valg2013$Fylke))
colnames(valg2013)[6] <- "Kommunestemmer"
kommunetotal <- aggregate(Kommunestemmer ~ KommuneID, data = valg2013, sum)
colnames(kommunetotal)[2] <- "Kommunetotal"
valg2013 <- join(valg2013, kommunetotal)
valg2013$Kommuneprosent <- valg2013$Kommunestemmer / valg2013$Kommunetotal * 100
fylkestotal <- aggregate(Kommunestemmer ~ FylkeID, data = valg2013, sum)
colnames(fylkestotal)[2] <- "Fylkestotal"
fylkesstemmer <- aggregate(Kommunestemmer ~ FylkeID + Parti, data = valg2013,
                           sum)
colnames(fylkesstemmer)[3] <- "Fylkesstemmer"
fylkesstemmer <- join(fylkesstemmer, fylkestotal)
fylkesstemmer$Fylkesprosent <- fylkesstemmer$Fylkesstemmer /
  fylkesstemmer$Fylkestotal * 100
valg2013 <- join(valg2013, fylkesstemmer)
landsstemmer <- aggregate(Kommunestemmer ~ Parti, data = valg2013, sum)
colnames(landsstemmer)[2] <- "Landsstemmer"
landsstemmer$Landstotal  <- sum(landsstemmer$Landsstemmer)
landsstemmer$Landsprosent <- landsstemmer$Landsstemmer /
  landsstemmer$Landstotal * 100
valg2013 <- join(valg2013, landsstemmer)

parti <- read.csv("~/Documents/R/Valg 2013/parti.csv")
parti$Partinavn <- factor(parti$Partinavn, parti$Partinavn)

valg2013$Parti <- factor(valg2013$Parti, parti$Parti)
valg2013 <- join(valg2013, parti)
