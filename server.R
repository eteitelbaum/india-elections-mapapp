shinyServer(function(input, output, session) {
  
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
      #map_data # DO WE STILL NEED TO RETURN THE SF OBJECT?
  })
  
  #base leaflet
  output$election_map = renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
      setView(lng = 77, lat = 20, zoom = 5) %>%
      addLegend(position = "bottomright", 
                pal = pal,
                values = c("BJP", "BJP+", "INC", "INC+", "Other", "NA"),
                title = "Coalitions",
                opacity = 1)
  })
  
  #Incremental changes to the map performed in an observer & leafletProxy
  observe({
    
    labels <- sprintf(
      "State: %s<br>Coalition: %s",
      map_df()$state_name, map_df()$bjp_inc_other
    ) %>% lapply(htmltools::HTML)
    
    leafletProxy("election_map") %>%
      clearShapes() %>%
      addPolygons(data = map_df(),    #mad_df is a FUNCTION! because created with reactive()
                  #layerId = ~map_df()$state_name,
                  fillColor = ~pal(map_df()$bjp_inc_other), # WHY A TILDE? ~pal
                  fillOpacity = 0.7,
                  stroke = TRUE, 
                  weight = 1,
                  smoothFactor = 1, #default: 1 - larger numbers improve performance & smooth polygon
                  label = labels,
                  labelOptions = labelOptions(
                       style = list("font-weight" = "normal", padding = "3px 8px"),
                       textsize = "15px",
                       direction = "auto")
                  ) 
  })
})


#Improvement idea: keep the polygons of the previous map while the new ones render

#Giving an object a layer ID, if a similar object exists with the same ID, it will be removed from the map when the new object is added
#Would allow to NOT use clearShapes() before the new polygons render! 
#Layer ID = vectorized argument: if adding 50 polygons, need to pass either NULL or a 50-element character vector as layerId value. 
#-> If single-element character vector as layerId, all of the polygons will have the same ID, and all but the last polygon will be removed!

#layerId = ~map_df()$state_name  
# > will map one layerID for each polygon depending on its state_name

#Problem: when changing year, if a state changes name, its polygon colour will NOT be removed as its layerID will not reappear in the new mapping
# = leads to superposition

#Solution (?): if condition 
#  if year change leads to state change: clearShapes() necessary
#   else: all state names stay the same and it is possible to use layerId

#[https://github.com/rstudio/leaflet/issues/434]
#[https://rstudio.github.io/leaflet/shiny.html]
