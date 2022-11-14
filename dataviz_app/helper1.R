#load & clean shapefiles
states2014_shp <- st_read(dsn ="../shapefiles/state-shape/states-2014/states_2014.shp") %>%
  filter(GID_0 == "IND" | GID_0 == "Z01") %>%
  rename(state_name = NAME_1) %>%
  mutate(
    state_name = str_replace_all(state_name, " and ", " & "), 
    state_name = str_replace(state_name, "NCT of Delhi", "Delhi")
  )

states2020_shp <- st_read(dsn ="../shapefiles/state-shape/states-2020/states_2020.shp") %>%
  rename(state_name = ST_NM)


#load & clean state election data 
coalitions_df <- read_csv("../election-results/state-level-coalitions.csv") %>%
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

#function that maps !!

map_year <- function(selected_year) {
  
  # filter, arrange, slice 
  selected_data <- coalitions_df %>%
    filter(year <= selected_year) %>%
    group_by(state_name) %>%
    arrange(year) %>%
    slice_max(year, n = 1)
  
  # join to shapfile
  # if/then statements here for maps for different years 
  if(selected_year < 2020){
    map_data <- left_join(states2014_shp, selected_data, by ="state_name")
  }
  
  else{
    map_data <- left_join(states2020_shp, selected_data, by ="state_name")
  }
  
  
  # create map
  elections_plt <- tm_shape(map_data)+
    tm_fill("bjp_inc_other",
            palette = group.colors,
            title = "Ruling Coalition")+
    tm_borders(col = "grey40", lwd = .5, lty = "solid", alpha = .4)
  

  return(elections_plt)
}