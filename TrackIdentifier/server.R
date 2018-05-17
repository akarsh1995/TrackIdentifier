#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

source(file = "ContentRetrieval.R")
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    output$trackinfo <- renderDataTable({
      resp.content <- getmusicdata(input$mp3file$datapath)
      resp.content<-resp.content$metadata%>%unlist%>%as.data.frame()
      resp.content<- cbind(row.names(resp.content), resp.content)
      resp.content
  })
  
})
