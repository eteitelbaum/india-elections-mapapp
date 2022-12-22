# load and clean geopackage
states_72_00 <- st_read("state_maps.gpkg", layer = "states_1972_2000") %>%
  rename(state_name = ST_NM) 

states_00_14 <- st_read("state_maps.gpkg", layer = "states_2000_2014") %>%
  rename(state_name = ST_NM) 

states_14_19 <- st_read("state_maps.gpkg", layer = "states_2014_2019") %>%
  rename(state_name = ST_NM) 


#load & clean state election data 
coalitions_df <- read_csv("state-level-coalitions.csv") %>%
  rename(state_name = State_Name,
         year = Year
  ) %>%
  mutate(
    state_name = str_replace_all(state_name, "_", " "), 
    first_four = substr(winning_coalition, 1, 4), 
    bjp_inc_other = case_when(
      first_four == "BJP" ~ "BJP", 
      first_four == "BJP+" ~ "BJP+", 
      first_four == "INC" ~ "INC",
      first_four == "INC(" ~ "INC",
      first_four == "INC+" ~ "INC+", 
      TRUE ~ "Other" 
    )
  )

#colours for the mapping
group.colors <- c("BJP" = "#ff8100", 
                  "BJP+" = "#ffb348", 
                  "INC" = "#5da2cf", 
                  "INC+" = "#90cce7", 
                  "Other" = "#ffff66")

#mapping depending on the year

map_year <- function(selected_year) {
  
  # filter, arrange, slice 
  selected_data <- coalitions_df %>%
    filter(year <= selected_year) %>%
    group_by(state_name) %>%
    arrange(year) %>%
    slice_max(year, n = 1)
  
  # assign correct map based on selected year
  if (selected_year < 2001) {
    selected_map <- states_72_00
  } else if (selected_year > 2000 & selected_year < 2014) { 
    selected_map <- states_00_14
  } else {
    selected_map <- states_14_19
  }
  
  # join to shapfile
  map_data <- left_join(selected_map, selected_data, by ="state_name")
  
  
  # create map
  elections_plt <- tm_shape(map_data)+
    tm_fill("bjp_inc_other",
            palette = group.colors,
            title = "Ruling Coalition")+
    tm_borders(col = "grey40", lwd = .5, lty = "solid", alpha = .4)
  

  return(elections_plt)
}