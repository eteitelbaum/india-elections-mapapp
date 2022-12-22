#must start with loading shiny package
library(shiny)

#load all needed packages
library(tidyverse)
library(tmap)
library(sf)

#load helper script that does the state-level mapping
source("helper1-2.R") #contains the function 'map_year' that takes one year variable

# UI ----
ui <- fluidPage(
  #app title
  titlePanel(h1("Visualization of Election Winners in India", align = "center")),
  
  #basic structure: one panel for inputs & one for displaying outputs -> HTML inside
  sidebarLayout(

    #sidebar panel for inputs (position by default = left) -> add widgets
    sidebarPanel(
      helpText("Maps the winning coalition in each Indian State / Parliamentary Constituencies for the selected year"),
      #select box: elections
      selectInput("election", 
                  label = "Choose the election",
                  choices = list("State-level", 
                                 "Lok Sabha"),
                  selected = "State-level"),
      
      #slider: year
      sliderInput("year",
                  label = "Year Selected:",
                  sep="", #removes comma from numbers
                  min = 1977, max = 2021, value = 2021)
      ),
    
    #main panel for displaying outputs
    mainPanel(
      p("This project aims to provide detailed and accurate data visualization of ruling coalitions in India. 
        The web applications that will result from it will provide people interested in the evolution 
        of the Indian political landscape with a centralized tool to observe it."),
      h3(textOutput("SELECTED_ELECTION_YEAR")),
    
      plotOutput("MAP") #plots the output (MAP to be created in server with a render function)
    )
  )
)


# SERVER ----

server <- function(input, output) {
  
  output$SELECTED_ELECTION_YEAR <- renderText({ 
    paste("You have selected", input$election, "in", input$year )
  })
  
  output$MAP <- renderPlot({
    map_year(input$year)
  })
  

}

#wrap everything together
shinyApp(ui = ui, server = server)