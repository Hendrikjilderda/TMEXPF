# known bugs:
# /

library(shiny)
library(shinydashboard)
library(tidymodels)
library(tidyverse)
library(iBreakDown)

model  <- readRDS("GCR_xgmodel.rds")
explainer <- readRDS("GCR_xg_explainer.rds")
recipe <- readRDS("GCR_xg_rec.rds")

# testcase

# predict(
#     model,
#     tibble("Age" = 23,
#            "Sex" = 'male',
#            "Job" = 'skilled',
#            "Housing" = 'own',
#            "Saving.accounts" = 'rich',
#            "Checking.account" = 'rich',
#            "Credit.amount" = 2000,
#            "Duration" = 18,
#            "Purpose" = 'education',
#            "X" = 0),
#     type = "prob"
# ) %>%
#     gather() %>%            
#     arrange(desc(value)) %>% 
#     slice_head() %>%
#     select(value)



# Define UI for application that draws a histogram
ui <- dashboardPage(skin = "blue",
    dashboardHeader(title = "CJIB", titleWidth = '150px'),
    dashboardSidebar( width = 150,
        menuItem(
            "German Credit Risk",
            tabName = "GCR tab"
        )
    ),
    dashboardBody(
        tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 40px;
      }
    '))),

        tabItem(
            tabName = "GCR tab",

            plotOutput("BD_plot"),
            
            box(valueBoxOutput("GCR_prediction", width = 12), width = 12),
            
            box(selectInput("v_purpose", label = "Purpose",
                            choices = c("domestic appliances", 
                                        "furniture/equipment", "education", 
                                        "radio/TV", "repairs", "car", 
                                        "business", "vacation/others"))
            ,width = 4),
            
            box(selectInput("v_sex", label = "Sex",
                            choices = c("male", "female"))
            ,width = 4),
            
            box(selectInput("v_housing", label = "Housing",
                            choices = c("own", "rent", "free"))
            ,width = 4),
            
            box(selectInput("v_job", label = "Job",
                            choices = c("unskilled and non-resident", 
                                        "unskilled and resident", "skilled", 
                                        "highly skilled"))
            ,width = 4),
            box(selectInput("v_savings", label = "Savings",
                            choices = c("little", "moderate","rich"))
            ,width = 4),
            box(selectInput("v_checkings", label = "Checkings",
                            choices = c("little", "moderate", "rich"))
            ,width = 4),
            
            box(sliderInput("v_age", label = "Age",
                            min = 19, max = 75, value = 35)
            ,width = 12),
            box(sliderInput("v_creditamount", label = "Credit amount",
                            min = 276, max = 18242, value = 2300)
            ,width = 12),
            box(sliderInput("v_duration", label = "Duration",
                            min = 6, max = 72, value = 18)
            ,width = 4)    
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$BD_plot <- renderPlot({ 

      new_data <- tibble("Age" = input$v_age,
             "Sex" = input$v_sex,
             "Job" = input$v_job,
             "Housing" = input$v_housing,
             "Saving.accounts" = input$v_savings,
             "Checking.account" = input$v_checkings,
             "Credit.amount" = input$v_creditamount,
             "Duration" = input$v_duration,
             "Purpose" = input$v_purpose,
             "X" = 0)
      
      prep <- prep(recipe, verbose = TRUE)
      
      case <- bake(prep, new_data)
      
      BD_plot <- iBreakDown::local_attributions(explainer, 
                                                    case, 
                                                    keep_distributions = TRUE)
      
      plot(BD_plot)
    })
  
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
            gather() %>%            
            arrange(desc(value)) %>% 
            slice_head() %>%
            select(value)
            
            
        prediction_colour <- if_else(prediction$.pred_class == 1, "green", "red")

        valueBox(
            value = paste0(round(100*prob_prediction, 0), "%"),
            subtitle = paste0("Risk: ", if_else(prediction$.pred_class == 1, 'low', 'high')),
            color = prediction_colour,
            icon = icon("ok", lib = "glyphicon")
        )
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
