#must start with loading shiny package
library(shiny)

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
      h2("Map", align = "center"),
      p("This project aims to provide detailed and accurate data visualization of ruling coalitions in India. The web applications that will result from it will provide people interested in the evolution of the Indian political landscape with a centralized tool to observe it."),
      h3("[output displayed here]"))
  )
)

# SERVER ----

server <- function(input, output) {
  
}

#wrap everything together
shinyApp(ui = ui, server = server)