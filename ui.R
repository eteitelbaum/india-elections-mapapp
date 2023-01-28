library("shiny")
library("shinythemes")
library("leaflet")
library("shinyWidgets")

rng <- 1977:2021

ui <- fluidPage(
  theme= shinytheme("lumen"),
  
  titlePanel(h1("Election Winners in India (1977-2021)", align = "center")),

  fluidRow(
    #12 columns on one row: this panel will take 1/4 of it
    column(3, wellPanel(
      selectInput("election", "Choose an election: ", 
                  c(
                    "State legislative assembly" = "state",
                    "Lok Sabha" = "lok_sabha")
                  ),
      includeHTML("about.html")
    )),
    
    
    column(8,
           leafletOutput("election_map", height = 600),
           sliderTextInput("map_year", "Year",
                           choices = rng,
                           selected = tail(rng, n = 1),
                           grid = T,
                           width = "100%")
           )
  )
)
