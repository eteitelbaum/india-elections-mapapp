#must start with loading shiny package
library(shiny)

# UI ----
ui <- fluidPage(
  #app title
  titlePanel(h1("Visualization of Election Winners in India", align = "center")),
  
  #basic structure: one panel for inputs & one for displaying outputs -> HTML inside
  sidebarLayout(

    #sidebar panel for inputs (position by default = left)
    sidebarPanel(
      h2("Inputs"),
      p("Here, users will be able to select a type of elections: State-level elections or General elections."),
      p("They will use a slider to determine the year mapped.")),
    
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

shinyApp(ui = ui, server = server)