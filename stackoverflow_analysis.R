#Data exploring and analysis

library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidytext)
library(tidyverse)
library(broom)
library(purrr)
library(scales)
theme_set(theme_bw())


#Most popular tags

setwd("/home/kenelly/workspaces/tagpredictor/")

stackdatacleaned <- read.csv('stackdatacleaned.csv')
str(stackdatacleaned)

#Count the frequency of tags
library(plyr)
populartags <- (count(stackdatacleaned, 'Tags'))

#Writing on CSV the count of Tags
write.csv(populartags, file = 'populartags.csv' )    

#Wordcloud to check the most frequent words on the data science questions - only to include on the report.

library(wordcloud)
library(NLP)
library(RColorBrewer)

stackpostsCorpus <- Corpus((VectorSource(stackdatacleaned$Posts)))

dtm <- TermDocumentMatrix(stackpostsCorpus)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
dt <- data.frame(words= names(v), freq=v)
head(dt,n = 100)

#wordcloud
wordcloud(words = dt$words, freq = dt$freq, min.freq = 1 ,max.words= 150, random.order = FALSE, scale=c(3,0.6),
          rot.per = 0.35, colors = brewer.pal(8, "Set1"))

