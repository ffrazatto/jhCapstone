#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Text Prediction App"),

    # Sidebar with a slider input for number of bins
        mainPanel( 
            titlePanel("Predictions"),
            actionButton("s1", ""),
            actionButton("s2", ""),
            textInput("text", h3("Text input"), 
                      value = "")
        
    
)
)
)
