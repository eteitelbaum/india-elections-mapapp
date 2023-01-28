library("shiny")
library("leaflet")
library("dplyr")

shinyServer(function(input, output) {
  
  #filter data according to chosen year & merge with the correct map layer
  #reactive = will only update when the input (map_year) changes
  map_df <- reactive({
    
      map_data <- data %>%
        filter(year <= input$map_year) %>%
        group_by(state_name) %>%
        arrange(year) %>%
        slice_max(year, n = 1)
    
      if (input$map_year < 2001) {
        map_data <- left_join(states_72_00, map_data, by ="state_name")
      } 
      else if (input$map_year > 2000 & input$map_year < 2014) { 
        map_data <- left_join(states_00_14, map_data, by ="state_name")
      } 
      else {
        map_data <- left_join(states_14_19, map_data, by ="state_name")
      }
      
      #return the sf
      map_data
  })
  
  #render the leaflet map
  #render = will only render when the reactive element inside of it (map_df) changes
  output$election_map = renderLeaflet({
    
    leaflet() %>%
      addTiles() %>%
      setView(lng = 77, lat = 20, zoom = 4.5)%>%
      #mad_df is a FUNCTION! because created with reactive()
      addPolygons(data = map_df(),
                  fillColor = ~pal(map_df()$bjp_inc_other)) %>%
      addLegend(position = "bottomright", pal = pal, values = map_df()$bjp_inc_other,
                title = "Coalitions",
                opacity = 1)

  })
  
})