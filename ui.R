library(shiny)
library(shinyBS)
library(googleVis)
library(dygraphs)

shinyUI(fluidPage(
  
  tabsetPanel(
              "Load Data",
             tabPanel("Start",
                       titlePanel("Load sample App Dataset"),
                  sidebarLayout(
                    sidebarPanel(
                      actionButton("action", "Load Data"),
                      helpText("Note: Please wait for approx 1min to load the sample data and other panels get enabled for analytics.")
                    ),    
                    mainPanel(
                      h5("Dataset loaded:"),
                      verbatimTextOutput('loaddata')
                    )
              )),
              "App Publisher & Product",  
              tabPanel("Select Mobile App",
                  conditionalPanel("output.loaded",
                       titlePanel("Select App Details:"),
                       sidebarLayout(
                         sidebarPanel(
                           
                           selectInput("Genre", 
                                       label = "Genre :",
                                       choices = c("Gaming",
                                                   "Social Networking",
                                                   "Productivity",
                                                   "Health & Fitness"),
                                       selected="Productivity",
                                       selectize=F),
                           
                           selectInput("AppPublisher", 
                                       label = "Publisher :",
                                       choices = "Ginger Labs, Inc.",
                                       selectize=F),
                           
                           checkboxInput("motionchart", "Display Motion Chart of Apps from this Publisher:",FALSE),
                           
                           selectInput("AppName", 
                                       label = "App Name :",
                                       choices = "",
                                       selectize=F),
                           
                           selectInput("AppCategory", 
                                       label = "Category :",
                                       choices = "",
                                       selectize=F)        
                                         
                           ),
                         mainPanel(
                           h4("App Dataset availability:"),
                           htmlOutput("text"),
                           conditionalPanel(
                             condition="input.motionchart",
                             tableOutput("gvMotion")
                           )
                           
                          )
                        )
                  )
             ),
              
              "Modeling",         
              tabPanel("Model Performance Estimation",
                 conditionalPanel(
                   condition="output.flag=='1'",
                   
                       titlePanel("Train, Test and compare Performance Metrics"),
                       sidebarLayout(
                         sidebarPanel(
                           selectInput("modelPerf", 
                                       label = "Predictive model type:",
                                       choices = c("SVM"="SVM",
                                                   "Random Forest"="Random Forest",
                                                   "LM"="LM",
                                                   "Decision Trees(Rpart)"="Decision Trees(Rpart)",
                                                   "custom Workflow" = "custom Workflow",
                                                   "MARS" = "MARS"),
                                       selected = "SVM",
                                       selectize=F),
                           
                           bsTooltip("model", "Predictive Models to choose","right", options = list(container = "body")),
                           br(),                          
                           
                           sliderInput("partition", "Select Training Depth(%)", min=0, max=100, value = 70),
                           
                           
                           
                           selectInput("metrics", 
                                       label = "Regression Model Evaluation Metric :",
                                       choices = c("absolute error metrics - mean absolute error" = "mae",
                                                   "absolute error metrics - mean squared error" = "mse",
                                                   "absolute error metrics - root mean squared error" = "rmse",
                                                   "Relative error metrics - nmse" = "nmse",
                                                   "Relative error metrics - theil" = "theil",
                                                   "Relative error metrics - nmae" = "nmae",
                                                   "all"="all"),
                                       selected="Relative error metrics - theil",
                                       selectize=F),
                           helpText(" Note: The theil metric is typically used in time series tasks and the used baseline is the last observed value of the target variable.")
                           
                         ),
                         mainPanel(
                           conditionalPanel(
                             condition="output.flag=='1'",
                               dygraphOutput("PlotPredictedHoldOut"),
                               tabsetPanel(
                                 tabPanel('Compare Models',
                                      tabsetPanel(
                                        tabPanel('Model Performance',plotOutput('Performance')),  
                                        tabPanel('Performance Summary', tableOutput("ModelSummary")),
                                        tabPanel('Performance Rank', tableOutput("RankModels")),
                                        tabPanel('Top Performer', tableOutput("topPerformer"))
                                        )
                                      ),
                                 tabPanel('Train/Test Data',tableOutput('TrainTable')),
                                 tabPanel('HoldOut Test Data',tableOutput('HoldOutTestTable')),
                                 tabPanel('Model Prediction',tableOutput('Prediction'))
                                 
                              )
                           )
                         )
                       )              
              )),
                
              "Forecasting",         
              tabPanel("Model based forcasting of App Rank",
                       
                   conditionalPanel(
                     condition="output.flag=='1'",
                         
                       titlePanel("Model based App Rank forecast"),
                       sidebarLayout(
                         sidebarPanel(
                           helpText("Select below options to forecast future App rank"), 
                           selectInput("model", 
                                       label = "Predictive model type:",
                                       choices = c("SVM"="SVM",
                                                   "Random Forest"="Random Forest",
                                                   "LM"="LM",
                                                   "Decision Trees(Rpart)"="Decision Trees(Rpart)",
                                                   "custom Workflow" = "custom Workflow",
                                                   "MARS" = "MARS"),
                                       selected = "SVM",
                                       selectize=F),
                            
                           bsTooltip("model", "Predictive Models to choose","right", options = list(container = "body")),
                            br(),                          
                            sliderInput("daystoforecast", "Number of days to forcast :", min=1, max=30, value = 15),
                            checkboxGroupInput("Attributes", "Plot other Attributes:",
                                              c("Delt1"="Delt1",
                                                "Delt2"="Delt2",
                                                "Delt3"="Delt3",
                                                "Delt4"="Delt4",
                                                "Delt5"="Delt5",
                                                "volatility"="Volat",
                                                "EMA" = "EMA",
                                                "None"=""),
                                               selected = "None"),
                            
                            bsTooltip("Attributes", "Attributes other than Rank","right", options = list(container = "body"))
                           
                         ),
                         mainPanel(
                          
                           dygraphOutput("RankPlot2"),
                                   tabsetPanel(
                                     tabPanel('Forecasted App Rank',tableOutput('Forecast')),
                                     tabPanel('Historical App Data',tableOutput('Data'))
                                   )
                         )
                  )              
               )
              ) #conditional flag              
          )
))
