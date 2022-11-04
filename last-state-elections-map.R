library(tidyverse)
library(tmap)
library(sf)

# load and clean shapefiles
states2001_shp <- st_read(dsn ="state-shape/states-2001/states_2001.shp")
# this works but unfortunately the state names are not in the shape file, 
# so it can't be merged with the coalition data at th moment

# test_2001 <- tm_shape(states2001_shp) 
# test_2001 <- test_2001 + tm_borders(col = "grey40", lwd = .5, lty = "solid", alpha = .4)
# test_2001

states2014_shp <- st_read(dsn ="state-shape/states-2014/states_2014.shp") %>%
  filter(GID_0 == "IND" | GID_0 == "Z01") %>%
  rename(state_name = NAME_1) %>%
  mutate(
    state_name = str_replace_all(state_name, "and", "&"), 
    state_name = str_replace(state_name, "NCT of Delhi", "Delhi")
  )

test_2014 <- tm_shape(states2014_shp) 
test_2014 <- test_2014 + tm_borders(col = "grey40", lwd = .5, lty = "solid", alpha = .4)
test_2014

states2020_shp <- st_read(dsn ="state-shape/states-2020/states_2020.shp") %>%
  rename(state_name = ST_NM)

# load and clean election data
coalitions_df <- read_csv("election-results/state-level-coalitions.csv") %>%
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

# select last election 
last_elections_df <- coalitions_df %>% group_by(state_name) %>% slice_max(year, n = 1)

# merge shapefile & data
final <- left_join(states2020_shp, last_elections_df, by ="state_name" )

# map winning coalitions using tmap
last_elections_plt<- tm_shape(final)
last_elections_plt <- last_elections_plt + tm_borders(col = "grey40", lwd = .5, lty = "solid", alpha = .4)
last_elections_plt <- last_elections_plt + tm_fill(col = "winning_coalition")
last_elections_plt


# next: nex variable collapsing winning coalitions into "BJP", "BJP+", etc...
# customize colors of label in tmap to fit usual party colors (e.g. saffran, blue)


# create list of most recent elections

vs_elections <- coalitions_df %>%
  distinct(year) %>%
  arrange(year)
vs_elections # no elections in 1981 and 1986

# create a function that selects data in each state for election closest to 
# year selected by user and maps it

map_year <- function(selected_year) {

# filter, arrange, slice 
selected_data <- coalitions_df %>%
  filter(year <= selected_year) %>%
  group_by(state_name) %>%
  arrange(year) %>%
  slice_max(year, n = 1)

# join to shapfile
# need if/then statements her for maps for different years 
map_data <- left_join(states2020_shp, selected_data, by ="state_name")

# create map
elections_plt <- tm_shape(map_data) 
elections_plt <- elections_plt + tm_borders(col = "grey40", lwd = .5, lty = "solid", alpha = .4)
elections_plt <- elections_plt + tm_fill(col = "bjp_inc_other")

# return map
return(elections_plt)

}

map_year(2018)
