#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidymodels)
library(tidyverse)

model  <- readRDS("GCR_xgmodel.rds")


# Define UI for application that draws a histogram
ui <- dashboardPage(
    dashboardHeader(title = "CJIB"),
    dashboardSidebar(
        menuItem(
            "German Credit Risk",
            tabName = "GCR tab"
        )
    ),
    dashboardBody(
        tabItem(
            tabName = "GCR tab",
            
            box(valueBoxOutput("GCR_prediction")),
            
            box(selectInput("v_purpose", label = "Purpose",
                            choices = c("domestic apliances", "furniture", "education", "radio/tv", "repairs", "others"))
            ),
            
            box(selectInput("v_sex", label = "Sex",
                            choices = c("male", "female"))
            ),
            
            box(selectInput("v_housing", label = "Housing",
                            choices = c("own", "rent", "free"))
            ),
            
            box(selectInput("v_job", label = "Job",
                            choices = c("unskilled and non-resident", "unskilled and resident", "skilled", "highly skilled"))
            ),
            box(selectInput("v_savings", label = "Savings",
                            choices = c("little", "moderate", "quite rich", "rich"))
            ),
            box(selectInput("v_checkings", label = "Checkings",
                            choices = c("little", "moderate", "quite rich", "rich"))
            ),
            
            box(sliderInput("v_age", label = "Age",
                            min = 19, max = 75, value = 35)
            ),
            box(sliderInput("v_creditamount", label = "Credit amount",
                            min = 276, max = 18242, value = 2300)
            ),
            box(sliderInput("v_duration", label = "Duration",
                            min = 6, max = 72, value = 18)
            )    
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$GCR_prediction <- renderValueBox({
        
        prediction <- predict(
            model,  
            tibble("Age" = input$v_age,
                    "Sex" = input$v_sex,
                    "Job" = input$v_job,
                    "Housing" = input$v_housing,
                    "Saving.accounts" = input$v_savings,
                    "Checking.account" = input$v_checkings,
                    "Credit.amount" = input$v_creditamount,
                    "Duration" = input$v_duration,
                    "Purpose" = input$v_purpose,
                   "X" = 0)
            )
        prob_prediction <- predict(
            model,  
            tibble("Age" = input$v_age,
                   "Sex" = input$v_sex,
                   "Job" = input$v_job,
                   "Housing" = input$v_housing,
                   "Saving.accounts" = input$v_savings,
                   "Checking.account" = input$v_checkings,
                   "Credit.amount" = input$v_creditamount,
                   "Duration" = input$v_duration,
                   "Purpose" = input$v_purpose,
                   "X" = 0),
            type = "prob"
        ) %>%
            gather()
            
        prediction_colour <- if_else(prediction$.pred_class == "good", "green", "red")
        
        valueBox(
            value = paste0(round(100*prob_prediction, 0), "%"),
            subtitle = paste0("Risk", prediction$.pred_class),
            color = prediction_colour
        )

    })

}

# Run the application 
shinyApp(ui = ui, server = server)
