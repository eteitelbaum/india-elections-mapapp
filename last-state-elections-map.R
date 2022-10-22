library(tidyr)
library(dplyr)
library(tmap)
library(sf)

#load shapefile
states_shp <- st_read(dsn ="state-shape/Admin2.shp")

#load election data
coalitions_df <- read.csv("election-results/state-level-coalitions.csv")
#select last election & create new variable without underscores
last_elections_df <- coalitions_df %>% group_by(State_Name) %>% top_n(1, Year)
last_elections_df$ST_NM <- gsub("_", " ", last_elections_df$State_Name)

#merge shapefile & data
final <- left_join(states_shp, last_elections_df, by ="ST_NM" )

#map winning coalitions using tmap
last_elections_plt<- tm_shape(final)
last_elections_plt <- last_elections_plt + tm_borders(col = "grey40", lwd = .5, lty = "solid", alpha = .4)
last_elections_plt <- last_elections_plt + tm_fill(col = "winning_coalition")
last_elections_plt


#next: nex variable collapsing winning coalitions into "BJP", "BJP+", etc...
#customize colors of label in tmap to fit usual party colors (e.g. saffran, blue)
