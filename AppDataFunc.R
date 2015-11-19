library(dplyr)
library(plyr)


# Written by Ashish Soni

appDet <- read.csv("application_details.csv", header=TRUE,sep=",")
colnames(appDet)<-c("Genre","app_id","app_name","download_size","publisher","device",paste0("Inf",1:5))
appDet$app_name<-as.character(appDet$app_name)

topgross<-read.csv("top_grossing_ranking.csv", header=F,sep=",")
colnames(topgross)<- c("Date","Genre","app_id","Rank")

freerank <- read.csv("top_free_ranking.csv", header=TRUE,sep=",")
colnames(freerank)<- c("Date","Genre","app_id","Rank")

paid <- read.csv("top_paid_ranking.csv", header=TRUE,sep=",")
colnames(paid)<- c("Date","Genre","app_id","Rank")
paid<-arrange(paid,Genre,app_id,Date)

price <- read.csv("price.csv", header=F,sep=",")
colnames(price) <- c("Genre","app_id","Date","price")
price<-arrange(price,Genre,app_id,Date)

ratings <- read.csv("rating_version.csv", header=F,sep=",")
colnames(ratings) <- c("Genre","app_id","Date","version","ratings","ratingcount")
ratings<-ratings[c("Date","app_id","Genre","version","ratings","ratingcount")]
ratings<-arrange(ratings,Genre,app_id,Date)

ratings_6014 <- read.csv("rating_version_6014.csv", header=F,sep=",")
colnames(ratings_6014) <- c("Genre","app_id","Date","version","ratings","ratingcount")
ratings_6014<-ratings_6014[c("Date","app_id","Genre","version","ratings","ratingcount")]
ratings_6014<-arrange(ratings_6014,Genre,app_id,Date)

releasedate <- read.csv("release_date.csv", header=F,sep=",")
colnames(releasedate) <- c("Genre","app_id","Date")
releasedate<-arrange(releasedate,Genre,app_id,Date)

# app ids with most entries
#list_free_appIDs<-((as.data.frame(table(freerank$app_id)) %>% arrange(desc(Freq),Var1)))[1]
#id<-as.numeric(as.character(list_free_appIDs[i,]))
#range<-"2015-01-01/2015-12-31"

# 
 choices = c("King.com Limited","Activision Publishing, Inc.", "Electronic Arts Inc.")
# 
# # for(i in 1:length(choices)){
#    publisher_name<-choices[i]
#    Pub_info<-unique(subset(appDet, publisher == publisher_name, c(1,2,3,6)))
#    app_names<-as.data.frame(Pub_info$app_name)
#    save(app_names,file=paste0("./data/",paste0(strsplit(choices[i]," ")[[1]][1],".RData")))
# }


