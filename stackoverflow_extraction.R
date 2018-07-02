#Extraction

setwd("/home/kenelly/workspaces/tagpredictor/")
library(XML)
library(data.table)
library(Amelia)

#Convert XML to data frame
stackxml <- xmlParse("Posts.xml")
postslist <- xmlToList(stackxml)

postslist <- lapply(postslist, function(x) as.data.table(as.list(x)))

stackposts <- rbindlist(postslist, use.names = T, fill = T)

#Checking missing values
missmap(stackposts, main = "Missing Values vs Observed", y.cex = 0.5, x.cex = 0.7 )
print(sapply(stackposts, function(x) sum(!is.na(x))))

#Getting only posts and tags
stackpoststags <- stackposts
stackpoststags <- stackpoststags[, -c(1:5)]
stackpoststags <- stackpoststags[, -c(2:4)]
stackpoststags <- stackpoststags[, -c(3:13)]

#Remove rows where tha Tag is empty
stackpoststags <- stackpoststags[!(is.na(stackpoststags$Tags)),]
str(stackpoststags)
    
#Writing on CSV Posts and related Tags
write.csv(stackpoststags, file = 'stackpoststags.csv')


#Count the frequency of tags
library(plyr)
tagsfreq <- (count(stackposts, 'Tags'))

#Writing on CSV the count of Tags
write.csv(tagsfreq, file = "tagsfreq.csv")

