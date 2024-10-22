# server.R

source("ultilityfunctions.R")
library(shiny)
library(dygraphs)
library(googleVis) 

removeDuplicates<-function(df){
}


#reactive
shinyServer(function(input, output,session){

  output$loaddata <- renderPrint({
    input$action
    isolate({
      source("AppDataFunc.R")
      if(is.null(appDet)){
        text1<-"App dataset not loaded. Please wait...."
      } else {
        text1="App dataset is Loaded. Now proceed to analytics"
      }
      HTML(paste(text1,sep = '<br/>'))
    })
  })
  
  output$loaded <- reactive({
    return(!is.null(appDet))
  })
  outputOptions(output, 'loaded', suspendWhenHidden=FALSE)
  
  app_publisher_info<-reactive({
    
    
    app_genre<-input$Genre
    if (app_genre=="Gaming"){
      app_publisher<-c("King.com Limited","Activision Publishing, Inc.","Electronic Arts Inc.")
    
    }else if(app_genre=="Health & Fitness"){
      app_publisher<-c("Northcube AB","Ariyana Felfeli", "Weight Watchers International, Inc.")

    }else if(app_genre=="Productivity"){
      app_publisher<-c("Ginger Labs, Inc.")

    }else if(app_genre=="Social Networking"){
      app_publisher<-c("eHarmony.com","MeetMe, Inc.")
    
    }else {
      app_publisher<-c("King.com Limited","Activision Publishing, Inc.","Electronic Arts Inc.")
  }

    app_publisher<-as.list(app_publisher)
    
  })
  
  
  observe({
    updateSelectInput(session,"AppPublisher",choices=app_publisher_info())
  })
  
  app_names<-reactive({
    
    publisher_name<-input$AppPublisher
    appDet$app_name<-as.character(appDet$app_name)
    Pub_info<-as.data.frame(unique(subset(appDet, publisher == publisher_name, c(1,2,3,6))))
    app_names<-Pub_info$app_name
    
    app_names
  })
  
  observe({
    updateSelectInput(session,"AppName", choices = app_names())
  })
  
  
  AppRankdata<-reactive({
  
    publisher_name<-input$AppPublisher
  
    Pub_info<-as.data.frame(unique(subset(appDet, publisher == publisher_name, c(1,2,3,6))))
    #id<-Pub_info$app_id
    Genreid<-Pub_info$Genre
    app_names<-as.data.frame(Pub_info$app_name)
    
    id<-Pub_info[which(Pub_info$app_name==input$AppName),"app_id"]
    
    
    tp<-paid[which(paid$app_id==id),c("Date","Rank")]%>% arrange(Date,Rank)
    tf<-freerank[which(freerank$app_id==id),c("Date","Rank")]%>% arrange(Date,Rank)
    tg<-topgross[which(topgross$app_id==id),c("Date","Rank")] %>% arrange(Date,Rank)
    
    xtp<-as.xts(tp$Rank,as.Date(tp$Date))
    xtf<-as.xts(tf$Rank,as.Date(tf$Date))
    xtg<-as.xts(tg$Rank,as.Date(tg$Date))
    
    return(list(paid=xtp,free=xtf,grossing=xtg))
})
  
  
  
  app_category_info<-reactive({
    

    free_data=0
    paid_data=0
    grossing_data=0
    if(nrow(AppRankdata()$free)==0){
      text1<-"Top free app data NOT AVAILABLE"
    } else {
      text1="Top free app data AVAILABLE"
      free_data=1
    }
    
    if(nrow(AppRankdata()$paid)==0){
      text2<-"Top paid app data  NOT AVAILABLE"
    }else{
      text2="Top paid app data AVAILABLE"
      paid_data=1
    } 
    
    if(nrow(AppRankdata()$grossing)==0){
      text3<-"Top grossing data  NOT AVAILABLE"
    }else{
      text3<-"Top grossing data AVAILABLE"
      grossing_data=1
    }
    flag<-1
    text4=""
    if(free_data==0&paid_data==0&grossing_data==0){
      choices=c("Data Not Avalilable for this App")
      flag<-0
      text4<-"Data Not Avalilable for this App to forecast"
    }
      
    if(free_data==0&paid_data==0&grossing_data==1)choices=c("Top Grossings")
    if(free_data==0&paid_data==1&grossing_data==0)choices=c("Top Paid")
    if(free_data==0&paid_data==1&grossing_data==1)choices=c("Top Paid","Top Grossings")
    if(free_data==1&paid_data==0&grossing_data==0)choices=c("Top Free")
    if(free_data==1&paid_data==0&grossing_data==1)choices=c("Top Free","Top Grossings")
    if(free_data==1&paid_data==1&grossing_data==0)choices=c("Top Free","Top Paid")
    if(free_data==1&paid_data==1&grossing_data==1)choices=c("Top Free","Top Paid","Top Grossings")

    return(list(text1=text1,text2=text2,text3=text3,text4=text4,free_data,paid_data,grossing_data,choices=choices,flag=flag))
    
  })
  

  observe({
    updateSelectInput(session,"AppCategory", choices = app_category_info()$choices)
  })
  
  output$flag <- reactive({
    app_category_info()$flag
  })
  
  outputOptions(output, 'flag', suspendWhenHidden=FALSE)
  
  output$text<-renderUI({
    
    text1<-app_category_info()$text1
    text2<-app_category_info()$text2
    text3<-app_category_info()$text3
    text4<-app_category_info()$text4
    HTML(paste(text1,text2,text3,text4,sep = '<br/>'))
    
  })


  output$gvMotion <- renderGvis({
    
    publisher_name<-input$AppPublisher
    
    Pub_info<-as.data.frame(unique(subset(appDet, publisher == publisher_name, c(1,2,3,6))))
    
    id<-Pub_info$app_id
    Genreid<-Pub_info$Genre
    app_names<-as.data.frame(Pub_info$app_name)
    
    
    #     Nid <-length(Pub_info$app_id)
    #     for(i in 1:Nid){
    #       app_name<-Pub_info$app_name[i]
    #       app_id<-Pub_info$app_id[i]
    #       tp<-paid[which(paid$app_id==id),c("Date","Rank")]%>% arrange(Date,Rank)
    #       tf<-freerank[which(freerank$app_id==id),c("Date","Rank")]%>% arrange(Date,Rank)
    #       tg<-topgross[which(topgross$app_id==id),c("Date","Rank")] %>% arrange(Date,Rank)
    #       lst<-list(list(app_name,app_id,tp,tf,tg))
    #       if(i==1) L<-lst else L<-c(L,lst)
    #     }
    
    
    id<-as.numeric(Pub_info$app_id)
    
    
    tp0<-paid[which(paid$app_id==id),c("Date","Rank","app_id")]%>% arrange(Date,Rank)
    tp<-merge(tp0, Pub_info[,c("app_id","app_name")], by.x=c("app_id"),by.y=c("app_id"),all=TRUE)
    
    tf0<-freerank[which(freerank$app_id==id),c("Date","Rank","app_id")]%>% arrange(Date,Rank)
    tf<-merge(tf0, Pub_info[,c("app_id","app_name")], by.x=c("app_id"),by.y=c("app_id"),all=TRUE)
    
    tg0<-topgross[which(topgross$app_id==id),c("Date","Rank","app_id")] %>% arrange(Date,Rank)
    tg<-merge(tg0, Pub_info[,c("app_id","app_name")], by.x=c("app_id"),by.y=c("app_id"),all=TRUE)
    
    tf$Date<-as.Date(tf$Date)
    tp$Date<-as.Date(tp$Date)
    tg$Date<-as.Date(tg$Date)
    
    ntp<-nrow(tp0)
    ntf<-nrow(tf0)
    ntg<-nrow(tg0)
  
    flag<-0
    if(ntf!=0)type<-"Top Free"
    if(ntp!=0)type<-"Top Paid"
    if(ntg!=0)type<-"Top Grossings"
    if(ntf==0&ntp==0&ntg==0)flag=1
    
    if(flag!=1){
    
     if(type=="Top Free")  df<-tf
     if (type=="Top Paid") df<-tp
     if (type=="Top Grossings") df<-tg
     
    df<-na.omit(df)
    df<-xts(df,as.Date(as.character.Date(df$Date)))
    # Take average of ranks on duplicated dates 
    date_index=index(df$Rank[which(duplicated(index(df$Rank))),])
    
    
    for(i in 1:length(date_index)){
      df$Rank[date_index[i]]<-as.character(mean(as.numeric(df$Rank[date_index[i]])))
    }
    
    
    #remove duplicates
    df<-df[!duplicated(index(df$Rank)), ]
    
       if(type=="Top Free"){
         tf<-data.frame(df)
         tf$Date<-as.Date(tf$Date)
         tf$Rank<-as.numeric(tf$Rank)
         m<-gvisMotionChart(tf,idvar="app_name",timevar = "Date",yvar="Rank",colorvar = "Rank")
       }else if (type=="Top Paid"){
         tp<-data.frame(df)
         tp$Date<-as.Date(tp$Date)
         tp$Rank<-as.numeric(tp$Rank)
         m<-gvisMotionChart(tp,idvar="app_name",timevar = "Date",yvar="Rank",colorvar = "Rank")
       }else if (type=="Top Grossings"){
         tg<-data.frame(df)
         tg$Date<-as.Date(tg$Date)
         tg$Rank<-as.numeric(tg$Rank)
         m<-gvisMotionChart(tg,idvar="app_name",timevar = "Date",yvar="Rank",colorvar = "Rank")
       }else{
         tf<-data.frame(df)
         tf$Date<-as.Date(tf$Date)
         tf$Rank<-as.numeric(tf$Rank)
         m<-gvisMotionChart(tf,idvar="app_name",timevar = "Date",yvar="Rank",colorvar = "Rank")
       }  
       if(input$motionchart)plot(m)
        return(m)
    }
    
  })
  
  
  prediction<-reactive({
    
    AppPublisher<-input$AppPublisher
    
    type<-input$AppCategory
    
    if(type=="Top Free")rank<-AppRankdata()$free
    else if (type=="Top Paid")rank<-AppRankdata()$paid
    else if (type=="Top Grossings")rank<-AppRankdata()$grossing
    else rank<-AppRankdata()$free
    
    
    # Take average of ranks on duplicated dates 
    date_index=index(rank[which(duplicated(index(rank))),])
    for(i in 1:length(date_index)){
      rank[date_index[i]]<-mean(rank[date_index[i]])
    }
    
    #remove duplicates
    rank<-rank[!duplicated(index(rank)), ]
    
    # time period
    range<-as.Date(min(index(rank)):max(index(rank)))
    
    start_date<-min(index(rank))
    end_date<-max(index(rank))
    
    # set missing Rank information to previous date or next date
    for(i in range){
      if(nrow(rank[range[i]]==0)){
        if(i>0) 
          rank[i]=rank[i-1]
        else 
          rank[i]=rank[i+1]
      }
    }
    
    # closing rank of App from 2015-01-01
    #clrank<-do.call("Cl",list(as.name(AppName)))['2015-01-01/']
    p<-rank
    data <- as.data.frame(cbind(Next(p),Delt(p,k=1:5),volatility(p),EMA(p)))
    
    
    colnames(data) <-c('rank',paste0("Delt",1:5),'Volat','EMA')
    
    rownames(data)<-index(p)+1
    
    # The latest rank is NA in data. This is the target which has to be predicted. 
    # We set this latest rank to 0 and will replace it with predicted rank.
    data[nrow(data),1]<-0
    
    
    # notice first few rows have NA aswell as the latest rank to predict is NA
    # Hence we will discard these rows  
    data<-na.omit(data)
    
    model<-input$modelPerf
    
    formula <-as.formula(rank ~ .)
    
    if(model=='SVM'){
      wf <- wf1
    } else if(model=='Random Forest'){
      wf <- wf2
    } else if(model=='LM'){
      wf <- wf3
    } else if(model=='Decison Trees(Rpart)'){
      wf <- wf4
    } else if(model=='custom Workflow'){
      wf <- wf5
    } else if(model=='MARS'){
      wf <- wf6
    } else {
      # default
      wf <- wf1
    }
    
    L=nrow(data)
    P=round(input$partition*L/100)
    start <- 1
    tr <- start:(start+P-1)
    ts <- (start+P):(start+L-1)
    train = data[tr,]
    holdOut = data[ts,]
    
    
    # Predict rank of lastest closing rank 
    out <- runWorkflow(wf,formula,train,holdOut)
    preds<-ceiling(out$preds)
    true<-out$true
    
    df<-cbind(preds,true)
    colnames(df)<-c('PredRank','TrueRank')
    
    df<-data.frame(df)
    return(list(df=df,tr=train,ts=holdOut))
    
  })
  
  
  output$TrainTable<-renderTable({
    #if(input$goButton)
    prediction()$tr
  })
  
  output$HoldOutTestTable<-renderTable({
    #if(input$goButton)
    prediction()$ts
  })
  
  
  ModelPerf<-reactive({  
    
    train<-prediction()$tr
    rownames(train)<-index(train)
    train<-data.frame(train)
#     path<-paste0(getwd(),"/train.csv",sep="")
#     browser()
#     write.csv(train, file = path, row.names = FALSE)
#     train <- read.csv(path, row.names=NULL, stringsAsFactors=FALSE)
    task<-PredTask(as.formula(rank ~ .),train,'Rank')
    #file.remove(path)
    spExp<-performanceEstimation(task,
                                 c(wf1,wf2,wf3,wf4,wf5,wf6),
                                 EstimationTask(metrics=input$metrics,
                                                method=MonteCarlo(nReps=10,szTrain=0.5,szTest=0.25)))
    
    spExp
    
})
  
  output$Performance<-renderPlot({  
    spExp<-ModelPerf()
    plot(spExp)
  })
  
  output$topPerformer<-renderTable({  
    spExp<-ModelPerf()
    top<-topPerformers(spExp)
    top$Rank
  })
  
  output$ModelSummary<-renderTable({  
    spExp<-ModelPerf()
    s<-summary(spExp)
    df<-data.frame(s$Rank)
    colnames(df)<-names(s$Rank)
    df
  })
    
  output$Prediction<-renderTable({  
    prediction()$df
  })
  
  output$RankModels<-renderTable({  
    spExp<-ModelPerf()
    s<-rankWorkflows(spExp)
    df<-s$Rank[[1]]
    df
  })
  
  output$PlotPredictedHoldOut <-renderDygraph({
    data<-as.xts(prediction()$df,as.Date(rownames(prediction()$df)))
    traintest<-as.xts(prediction()$tr,as.Date(rownames(prediction()$tr)))
    traintest<-traintest[,1]
    colnames(traintest)[1] <- "Train-TestSet"
    out<-cbind(data,traintest)
    dygraph(out,main=paste("Rank Prediction on Holdout set",input$AppName), ylab="Rank", xlab="Date") 
    
  })
  
  forecastRank<-reactive({
   
  AppPublisher<-input$AppPublisher

  type<-input$AppCategory
  
  if(type=="Top Free")rank<-AppRankdata()$free
  else if (type=="Top Paid")rank<-AppRankdata()$paid
  else if (type=="Top Grossings")rank<-AppRankdata()$grossing
  else rank<-AppRankdata()$free
  
  
  # Take average of ranks on duplicated dates 
  date_index=index(rank[which(duplicated(index(rank))),])
  for(i in 1:length(date_index)){
    rank[date_index[i]]<-mean(rank[date_index[i]])
  }
  
  #remove duplicates
  rank<-rank[!duplicated(index(rank)), ]
  
  # time period
  range<-as.Date(min(index(rank)):max(index(rank)))
  
  start_date<-min(index(rank))
  end_date<-max(index(rank))
  
  # set missing Rank information to previous date or next date
  for(i in range){
    if(nrow(rank[range[i]]==0)){
      if(i>0) 
        rank[i]=rank[i-1]
      else 
        rank[i]=rank[i+1]
    }
  }
  
  # closing rank of App from 2015-01-01
  #clrank<-do.call("Cl",list(as.name(AppName)))['2015-01-01/']
  p<-rank
  data <- as.data.frame(cbind(Next(p),Delt(p,k=1:5),volatility(p),EMA(p)))
  
  
  colnames(data) <-c('rank',paste0("Delt",1:5),'Volat','EMA')
  
  rownames(data)<-index(p)+1
  
  # The latest rank is NA in data. This is the target which has to be predicted. 
  # We set this latest rank to 0 and will replace it with predicted rank.
  data[nrow(data),1]<-0
  
  
  # notice first few rows have NA aswell as the latest rank to predict is NA
  # Hence we will discard these rows  
  data<-na.omit(data)
  
  model<-input$model
  
  formula <-as.formula(rank ~ .)

  if(model=='SVM'){
    wf <- wf1
  } else if(model=='Random Forest'){
    wf <- wf2
  } else if(model=='LM'){
    wf <- wf3
  } else if(model=='Decison Trees(Rpart)'){
    wf <- wf4
  } else if(model=='custom Workflow'){
    wf <- wf5
  } else if(model=='MARS'){
    wf <- wf6
  } else {
    # default
    wf <- wf1
  }
  
  # Predict rank of lastest closing rank 
  out <- runWorkflow(wf,formula,data[1:nrow(data)-1,],data[nrow(data),])
  preds<-out$preds
  
  
  # Append the predicted closing rank to the data rank rank
  data[nrow(data),]$rank<-preds
  
  temp_data<-data
  
  for(i in 1:input$daystoforecast){
  
    p<-temp_data$rank
    
    # Create a new data frame with future rank to predict and use below metrics
    df <- as.data.frame(cbind(Next(p),Delt(p,k=1:5),volatility(p),EMA(p)))
    
    # Rename Column names
    colnames(df)<-c('rank',paste0("Delt",1:5),'Volat','EMA')
    
    # Rename Rownames
    str<-c(as.character.Date(rownames(temp_data[2:nrow(temp_data),])),as.character.Date(as.Date(rownames(temp_data[nrow(temp_data),]))+1))
    rownames(df)<-str
    
    
    # The latest rank is NA in data. This is the target which has to be predicted. 
    # We set this latest rank to 0 and will replace it with predicted rank.
    df[nrow(df),1]<-0
    
    
    # notice first few rows have NA aswell as the latest rank to predict is NA
    # Hence we will discard the 33 rows while training the model and 
    df1<-na.omit(df)
    
    # Predict rank of lastest closing rank 
    out <- runWorkflow(wf,rank ~ .,df1[1:nrow(df1)-1,],df1[nrow(df1),])
    preds<-out$preds
    
    # Append the predicted closing rank to the data rank rank
    df[nrow(df),]$rank<-preds
    
    temp_data<-df

  }
  
  frank<-data.frame(ceiling(df$rank))
  rownames(frank)<-rownames(df)
  colnames(frank)<-c("ForecastedRank")
  forecast<-tail(frank,input$daystoforecast)
  df<-data.frame(forecast)
  return(list(df=df,initdata=data,start_date=start_date,end_date=end_date))
  
  })
  
  output$Forecast<-renderTable({
   
    forecastRank()$df
    
  })
  
  output$Data<-renderTable({
    
    forecastRank()$initdata
    
  })
  
   
  output$RankPlot <- renderPlot({
    data<-as.xts(forecastRank()$initdata,as.Date(rownames(forecastRank()$initdata)))
    
    start_date<-forecastRank()$start_date
    end_date<-forecastRank()$end_date
    
    y_lim=c(min(data[,1])-sd(data[,]),max(data[,1])+sd(data[,]))
    x_lim=as.POSIXct(c(start_date,end_date+input$daystoforecast))
    plot(data[,1], ylab="Rank", xlab="Date", main=paste("App rank of :",input$AppName),xlim=x_lim,ylim=y_lim)    
    
    rank <- forecastRank()$df 
    colInd <- rep("green", nrow(rank))
    colnames(rank)<-c('Predrank')
    Pred<-as.xts(rank$Predrank,as.Date(rownames(rank)))
    
    lines(Pred, col="red")
    points(Pred, col = colInd)
    legend("topleft", inset=.05,c("Historical","Forecasted"), fill=c("black","green"), horiz=TRUE)
    
  })
  


  output$RankPlot2 <-renderDygraph({
    data<-as.xts(forecastRank()$initdata,as.Date(rownames(forecastRank()$initdata)))

    colnames(data)[1] <- "Historical"
    start_date<-forecastRank()$start_date
    end_date<-forecastRank()$end_date
    rank <- forecastRank()$df 
    Pred<-as.xts(rank$ForecastedRank,as.Date(rownames(rank)))
    colnames(Pred)[1] <- "Forecasted"
    
    AttributesToPlot<-"Historical"
    if (input$Attributes!="") 
      AttributesToPlot<-c("Historical",input$Attributes[which(input$Attributes!="")])
    else
        AttributesToPlot<-"Historical"
      
    dygraph(cbind(data[,AttributesToPlot],Pred),main=paste("App rank of :",input$AppName), ylab="Rank", xlab="Date") 

    
  })
  
  
  
})
  
  
  
