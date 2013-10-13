library(plyr)
valg2013 <- read.csv("~/Documents/R/Valg 2013/valg2013.csv",
                     colClasses = c("factor",
                                    "character",
                                    "character",
                                    "factor",
                                    "factor",
                                    "NULL",
                                    "integer",
                                    rep("NULL", 5)))
colnames(valg2013)[6] <- "Kommunestemmer"
kommunetotal <- aggregate(Kommunestemmer ~ KommuneID, data = valg2013, sum)
colnames(kommunetotal)[2] <- "Kommunetotal"
valg2013 <- join(valg2013, kommunetotal)
fylkestotal <- aggregate(Kommunestemmer ~ FylkeID, data = valg2013, sum)
colnames(fylkestotal)[2] <- "Fylkestotal"
valg2013 <- join(valg2013, fylkestotal)
fylkesstemmer <- aggregate(Kommunestemmer ~ FylkeID + Parti, data = valg2013,
                           sum)
colnames(fylkesstemmer)[3] <- "Fylkesstemmer"
valg2013 <- join(valg2013, fylkesstemmer)
landsstemmer <- aggregate(Kommunestemmer ~ Parti, data = valg2013, sum)
colnames(landsstemmer)[2] <- "Landsstemmer"
valg2013 <- join(valg2013, landsstemmer)
valg2013$Landstotal <- sum(valg2013$Kommunestemmer)
valg2013$Kommuneprosent <- valg2013$Kommunestemmer / valg2013$Kommunetotal * 100
valg2013$Fylkesprosent <- valg2013$Fylkesstemmer / valg2013$Fylkestotal * 100
valg2013$Landsprosent <- valg2013$Landsstemmer / valg2013$Landstotal * 100
