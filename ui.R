library(shiny)
library(shinyBS)

shinyUI(fluidPage(
  
  tabsetPanel("App Publisher & Product",
              tabPanel("Mobile App Data ",
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
                           
                           selectInput("AppName", 
                                       label = "App Name :",
                                       choices = "Notability",
                                       selectize=F),
                           
                           selectInput("AppCategory", 
                                       label = "Category :",
                                       choices = "",
                                       selectize=F)
                           ),
                         mainPanel(
                           
                           htmlOutput("text")
                         )
                         )
                       ),
              
                           
              "Modeling",         
              tabPanel("Model based forcasting of App Rank",
                       titlePanel("Model based forcasting of App Rank"),
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
                           #plotOutput("RankPlot"),
                           dygraphOutput("RankPlot2"),
                                   tabsetPanel(
                                     tabPanel('Forecasted App Rank',tableOutput('Forecast')),
                                     tabPanel('Historical App Data',tableOutput('Data'))
                                   )
                         )
                  )              
               )              
          )
     
))
