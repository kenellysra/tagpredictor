#Extraction

setwd("/home/kenelly/workspaces/tagpredictor/")
library(XML)
library(data.table)
library(Amelia)

#Convert XML to data frame
stackxml <- xmlParse("Posts.xml")
postslist <- xmlToList(stackxml)

postslist <- lapply(postslist, function(x) as.data.table(as.list(x)))

stackdata <- rbindlist(postslist, use.names = T, fill = T)


#Writing on CSV. 
write.csv(stackdata, file = 'stackdata.csv')



