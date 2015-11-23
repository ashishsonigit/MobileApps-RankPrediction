library(performanceEstimation)
library(quantmod)
library(e1071)
library(randomForest)
library(DMwR)
library(earth)
library(rpart)

SVMparlist<-list(cost=10,gamma=0.01)
RFparlist<-list(ntree=500)


wf1<-Workflow('timeseriesWF',wfID="SVM",predictor='predict',
              pre=c("centralImp","scale"),
              .fullOutput=T,
              learner="svm",learner.pars=SVMparlist)

wf2<-Workflow('timeseriesWF',wfID="RF",predictor='predict',
              type="grow",relearn.step=30,.fullOutput=T,
              learner="randomForest",learner.pars=RFparlist)

wf3<-Workflow('timeseriesWF',wfID="LM",predictor='predict',
              type="grow",relearn.step=30,.fullOutput=T,
              learner="lm")

wf4<-Workflow('timeseriesWF',wfID="Rpart",predictor='predict',
              type="grow",relearn.step=30,.fullOutput=T,
              learner="rpart")

## A user-defined workflow
ensembleWF <- function(form,train,test,wL=0.5,...) {
  ml <- lm(form,train)
  mr <- rpart(form,train)
  pl <- predict(ml,test)
  pr <- predict(mr,test)
  ps <- wL*pl+(1-wL)*pr
  list(trues=responseValues(form,test),preds=ps)
}

wf5<- Workflow(wf="ensembleWF",wL=0.6,type="grow",relearn.step=30,.fullOutput=T)

wf6<- Workflow('timeseriesWF',wfID="Earth",predictor='predict',
                type="grow",relearn.step=30,.fullOutput=T,
                learner="earth")


# 
# train <- read.csv("~/Capstone/MobileAppShiny/train.csv", row.names=NULL, stringsAsFactors=FALSE)
# 
# task<-PredTask(as.formula(rank ~ .),train,'Rank')
# 
# spExp<-performanceEstimation(task,
#                              wf1,
#                              EstimationTask(metrics="theil",
#                                             method=MonteCarlo(nReps=10,szTrain=0.5,szTest=0.25)))
# plot(spExp)
