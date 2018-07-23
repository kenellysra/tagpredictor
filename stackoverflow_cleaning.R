#Cleaning

setwd("/home/kenelly/workspaces/tagpredictor/")

stackdatac <- read.csv('stackdata.csv')


#Checking missing values
missmap(stackdatac, main = "Missing Values vs Observed", y.cex = 0.5, x.cex = 0.7 )
print(sapply(stackdatac, function(x) sum(is.na(x))))
str(stackdatac)

#Remove rows where the Tag is empty
stackdatac <- stackdatac[!(is.na(stackdatac$Tags)),]
str(stackdatac)

#Removing some features
stackdatac <- stackdatac[, -c(1:3)]
stackdatac$OwnerUserId <- NULL
stackdatac$LastEditorDisplayName <- NULL
stackdatac$stackdatacOwnerDisplayName <- NULL
stackdatac$LastEditorUserId <- NULL
stackdatac$LastEditorUserId <- NULL
stackdatac$LastEditorDisplayName <- NULL
stackdatac$OwnerDisplayName <- NULL

library(stringr)

#Remove html tags and webpages
stackdatac$Body <- gsub("<.*?>", " ",stackdatac$Body)
stackdatac$Body <- str_replace_all(stackdatac$Body, "https://t.co/[a-z,A-Z,0-9]*"," ")
stackdatac$Body <- gsub("http\\w+", " ", stackdatac$Body)
stackdatac$Body <- str_replace_all(stackdatac$Body, "-"," ")

library(tm)

#Removing Pontuation, stop words, transforming to lowercase, etc
stackpostsCorpus <- Corpus((VectorSource(stackdatac$Body)))
stackpostsCorpus <- tm_map(stackpostsCorpus, content_transformer(tolower))
stackpostsCorpus <- tm_map(stackpostsCorpus, removeWords, c("<.*?>", "etc"))
stackpostsCorpus <- tm_map(stackpostsCorpus, removeWords, stopwords("english"))
stackpostsCorpus <- tm_map(stackpostsCorpus, removePunctuation)
stackpostsCorpus <- tm_map(stackpostsCorpus, stripWhitespace)

#Transforming Corpus in Data Frame
stackdatac$Body <- NULL
str(as.character(stackpostsCorpus))
stackdatacposts <-  data.frame(text=sapply(stackpostsCorpus, identity),stringsAsFactors=F)
str(stackdatac)
stackdatac$Posts <- stackdatacposts$text


str(stackdatac)
write.csv(stackdatac, file = 'stackdatacleaned.csv')
