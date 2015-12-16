library(dplyr)
library(plyr)

## 1 Access Data Source 
rm(list=all()) 
appDet <- read.csv("application_details.csv", header=TRUE,sep=",")
colnames(appDet)<-c("Genre","app_id","app_name","download_size","publisher","device",paste0("Inf",1:5))
appDet$app_name<-as.character(appDet$app_name)

# st<-appDet$download_size
# index<-grep("[0-9]",substring(appDet$download_size,1,1))
# appDet<-appDet[index,]
# appDet$download_size<-as.numeric(appDet$download_size)
# index<-which(appDet$download_size>0)
# appDet<-appDet[index,]
# appDet<-appDet[,1:6]

topgross<-read.csv("top_grossing_ranking.csv", header=F,sep=",")
colnames(topgross)<- c("Date","Genre","app_id","Rank")

freerank <- read.csv("top_free_ranking.csv", header=TRUE,sep=",")
colnames(freerank)<- c("Date","Genre","app_id","Rank")

paid <- read.csv("top_paid_ranking.csv", header=TRUE,sep=",")
colnames(paid)<- c("Date","Genre","app_id","Rank")
paid<-arrange(paid,Genre,app_id,Date)

train <- read.csv("temp.csv", row.names=NULL, stringsAsFactors=FALSE)
task<-PredTask(as.formula(rank ~ .),train,'Rank')