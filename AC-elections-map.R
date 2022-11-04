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
AC_shp <- st_read(dsn ="ac-shape/All_AC_sim_1.shp")

#test
ac_plt <- tm_shape(AC_shp) 
ac_plt <- ac_plt + tm_borders(col = "grey40", lwd = .5, lty = "solid", alpha = .4)
ac_plt
#"Error: Shape contains invalid polygons. Please fix it or set tmap_options(check.and.fix = TRUE) and rerun the plot"

tmap_options(check.and.fix = TRUE)
ac_plt
#works but "Warning message: The shape AC_shp is invalid. See sf::st_is_valid"


#load election data
ac_elections_df <- read_csv("election-results/lok-sabha-1977-2019.csv")
#constituency numbers DO NOT match those of the shapefile: use name comparisons to change them 
  #election data uses election number as per ECI
  #shapefile? (also use PC_NAME and not AC_NAME)



#check changes in constituency numbers & names:
n_distinct(AC_shp[AC_shp$ST_NAME == "ANDHRA PRADESH",]$PC_NAME)
#43 different constituencies in Andhra Pradesh in shapefile of current constituencies
unique(AC_shp[AC_shp$ST_NAME == "ANDHRA PRADESH",]$PC_NAME)

n_distinct(ac_elections_df[ac_elections_df$State_Name == "Andhra_Pradesh",]$Constituency_Name)
#48 different constituencies in Andhra Pradesh in election dataset
unique(ac_elections_df[ac_elections_df$State_Name == "Andhra_Pradesh",]$Constituency_Name)




