rng <- 1977:2021
title <- div(h1(strong("Election Winners in India (1977-2021)")))
windowtitle <- "Map - Election Winners in India"

ui <- fluidPage(
  theme= shinytheme("lumen"),
  
  titlePanel(title = title, windowTitle = windowtitle),

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
           leafletOutput("election_map", height = 900),
           sliderTextInput("map_year", "Year",
                           choices = rng,
                           selected = tail(rng, n = 1),
                           grid = T,
                           width = "100%")
           )
  )
)
