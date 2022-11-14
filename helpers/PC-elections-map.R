library(tidyverse)
library(tmap)
library(sf)
library(dplyr)

#some remarks:
#1)constituencies haven't changed since 1973 & our data only goes to 1977 -> should be OK
#2)BUT states have changed: 
    #if create a map with state borders too, take care of that
    #invalidates the count of constituencies in each state for old elections

# load and clean shapefiles
PC_shp <- st_read(dsn ="pc-shape/india_pc_2019.shp")

#test
pc_plt <- tm_shape(PC_shp) 
pc_plt <- pc_plt + tm_borders(col = "grey40", lwd = .5, lty = "solid", alpha = .4)
pc_plt
#"Error: Shape contains invalid polygons. Please fix it or set tmap_options(check.and.fix = TRUE) and rerun the plot"

tmap_options(check.and.fix = TRUE)
pc_plt
#works but "Warning message: The shape PC_shp is invalid. See sf::st_is_valid"


#load election data
pc_elections_df <- read_csv("election-results/lok-sabha-1977-2019.csv")

#check changes in constituency numbers & names:
n_distinct(PC_shp$PC_NAME) #540
n_distinct(pc_elections_df$Constituency_Name) #776


#understand how PC numbers work -> many have the same number: co's are numbered within the state



