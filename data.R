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
