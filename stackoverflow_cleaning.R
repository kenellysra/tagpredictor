#Cleaning

setwd("/home/kenelly/workspaces/tagpredictor/")

stackpoststags <- read.csv('stackpoststags.csv')

library(stringr)

#Remove html tags and webpages
stackpoststags$Body <- gsub("<.*?>", " ",stackpoststags$Body)
stackpoststags$Body <- str_replace_all(stackpoststags$Body, "https://t.co/[a-z,A-Z,0-9]*"," ")
stackpoststags$Body <- gsub("http\\w+", " ", stackpoststags$Body)
stackpoststags$Body <- str_replace_all(stackpoststags$Body, "-"," ")

library(tm)

#Removing Pontuation, stop words, transforming to lowercase, etc
stackpostsCorpus <- Corpus((VectorSource(stackpoststags$Body)))
stackpostsCorpus <- tm_map(stackpostsCorpus, content_transformer(tolower))
stackpostsCorpus <- tm_map(stackpostsCorpus, removeWords, c("<.*?>", "etc"))
stackpostsCorpus <- tm_map(stackpostsCorpus, removeWords, stopwords("english"))
stackpostsCorpus <- tm_map(stackpostsCorpus, removePunctuation)
stackpostsCorpus <- tm_map(stackpostsCorpus, stripWhitespace)

#Transforming Corpus in Data Frame
stackpoststagscleaned <- data.frame(text=sapply(stackpostsCorpus, identity),stringsAsFactors=F)
str(stackpoststags)

#Wordcloud to check the most frequent words on the data science questions - only to include on the report.
library(wordcloud)
library(NLP)
library(RColorBrewer)

dtm <- TermDocumentMatrix(stackpostsCorpus)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
dt <- data.frame(words= names(v), freq=v)
head(dt,n = 100)

#wordcloud
wordcloud(words = dt$words, freq = dt$freq, min.freq = 1 ,max.words= 200, random.order = FALSE, scale=c(2.8,.7),
          rot.per = 0.35, colors = brewer.pal(8, "Dark2"))


write.csv(stackpoststagscleaned, file = 'stackpoststagscleaned.csv')
