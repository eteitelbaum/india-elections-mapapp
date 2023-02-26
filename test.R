#Objects created in this file become available to the ui.R and server.R files: automatically sourced
#Create all the static objects here
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(htmltools)
library(arrow)
library(dplyr)
library(sf)
library(leaflet)
library(rmapshaper)


#load election dataset
data <- read_feather("state_coalitions.feather")
# write.csv(final_coalitions_df, "state_coalitions.csv", row.names=FALSE)

#load all three layers of the map
states_72_00 <- st_read("data/state_maps.gpkg", layer = "states_1972_2000") %>%
  rename(state_name = ST_NM) 

states_00_14 <- st_read("data/state_maps.gpkg", layer = "states_2000_2014") %>%
  rename(state_name = ST_NM) 

states_14_19 <- st_read("data/state_maps.gpkg", layer = "states_2014_2019") %>%
  rename(state_name = ST_NM) 


# colours for the leaflet map
pal <- colorFactor(palette = c("#ff8100", "#ffb348", "#5da2cf", "#90cce7", "#ffff66"), 
                   levels = c("BJP", "BJP+", "INC", "INC+", "Other"))

map_year <- 1999

map_data <- data %>%
  filter(year <= map_year) %>%
  group_by(state_name) %>%
  arrange(year) %>%
  slice_max(year, n = 1)

if (map_year < 2001) {
  map_data <- left_join(states_72_00, map_data, by ="state_name")
} else if (map_year > 2000 & map_year < 2014) { 
  map_data <- left_join(states_00_14, map_data, by ="state_name") 
} else {
  map_data <- left_join(states_14_19, map_data, by ="state_name") 
}

map_data <- ms_simplify(map_data, keep = 0.05, keep_shapes = TRUE)

labels <- sprintf(
     "<strong>State: %s</strong><br/>Coalition: %g",
     map_df()$state_name, map_df()$bjp_inc_other
   ) %>% lapply(htmltools::HTML)



