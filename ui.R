library(shiny)

# Written by Ashish Soni

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
                            br(),                          
                            sliderInput("daystoforecast", "Number of days to forcast :", min=1, max=30, value = 15)
                           
                         ),
                         mainPanel(
                           plotOutput("RankPlot"),
                                   tabsetPanel(
                                     tabPanel('Forecasted App Rank',tableOutput('Forecast'))
                                   )
                         )
                  )              
               )              
          )
     
))
