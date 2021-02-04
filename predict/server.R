#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
source("predict.R")
library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  ptext <- reactiveValues(value = NULL)
  

  observe({
    req(input$text)
    
    ptext$value1 <- pred(input$text)[1]
    ptext$value2 <- pred(input$text)[2]
    
    updateActionButton(session, "s1",
                       label = ptext$value1) 
    
    updateActionButton(session, "s2",
                       label = ptext$value2)
    


  })
  
  observeEvent(input$s1,{
    updateTextInput(session, "text", value = paste(input$text, ptext$value1))
  })  
  observeEvent(input$s2,{
    updateTextInput(session, "text", value = paste(input$text, ptext$value2))
  })
    

})
