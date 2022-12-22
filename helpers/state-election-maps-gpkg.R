library(tidyverse)
library(sf)

# # load and clean shapefile
# states2014_shp <- st_read("gadm41_IND.gpkg", "ADM_ADM_1") %>%
#   filter(GID_0 == "IND" | GID_0 == "Z01") %>%
#   rename(state_name = NAME_1) %>%
#   mutate(
#     state_name = str_replace_all(state_name, " and ", " & "), 
#     state_name = str_replace(state_name, "NCT of Delhi", "Delhi")
#   )

# load and clean geopackage
st_layers("state_maps.gpkg") # list layers 

states_72_00 <- st_read("state_maps.gpkg", layer = "states_1972_2000") %>%
  rename(state_name = ST_NM) 

states_00_14 <- st_read("state_maps.gpkg", layer = "states_2000_2014") %>%
  rename(state_name = ST_NM) 

states_14_19 <- st_read("state_maps.gpkg", layer = "states_2014_2019") %>%
  rename(state_name = ST_NM) 

# ggplot(states_72_00) + 
#   geom_sf() + 
#   theme_minimal()

# load and clean election data
coalitions_df <- read_csv("state-level-coalitions.csv") %>%
  rename(state_name = State_Name,
         year = Year
  ) %>%
  mutate(
    state_name = str_replace_all(state_name, "_", " "), 
    bjp_inc_other = case_when(
      str_detect(winning_coalition, fixed("BJP+")) == TRUE ~ "BJP+", 
      str_detect(winning_coalition, fixed("+BJP")) == TRUE ~ "BJP+", 
      str_detect(winning_coalition, fixed("BJP")) == TRUE ~ "BJP", 
      str_detect(winning_coalition, fixed("INC+")) == TRUE ~ "INC+",
      str_detect(winning_coalition, fixed("+INC")) == TRUE ~ "INC+",
      str_detect(winning_coalition, fixed("INC")) == TRUE ~ "INC",
      TRUE ~ "Other" 
    )
  )

#create map function

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
  group.colors <- c(BJP = "orange3", "BJP+" = "orange", 
                    INC ="dodgerblue3", "INC+" = "dodgerblue", 
                    Other = "yellow1")
  
  elections_plt <- ggplot() +
    geom_sf(data = map_data, aes(fill = bjp_inc_other)) +
    scale_fill_manual(values = group.colors) +
    labs(
      fill = "Coalition", 
      caption = "Source: Kay and Vaishnov, 2021", 
      title = paste("Winning coalitions in state assembly elections, ", selected_year)
    ) +
    theme_minimal()
  
  # return map
  return(elections_plt)
  
}

map_year(2017)
