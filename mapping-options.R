#Base map
library(tidyverse)
library(tmap)
library(sf)
library(ggplot2)

#Preparation ----
states2020_shp <- st_read(dsn ="shapefiles/state-shape/states-2020/states_2020.shp") %>%
  rename(state_name = ST_NM)

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

data_2019 <- coalitions_df %>%
  filter(year <= 2019) %>%
  group_by(state_name) %>%
  arrange(year) %>%
  slice_max(year, n = 1)

map <- left_join(states2020_shp, data_2019, by ="state_name")

group.colors <- c("BJP" = "#ff8100", 
                  "BJP+" = "#ffb348", 
                  "INC" = "#5da2cf", 
                  "INC+" = "#90cce7", 
                  "Other" = "#ffff66")




#TMAP ----
tmap1 <- tm_shape(map)+
  tm_polygons("bjp_inc_other", 
              palette = group.colors,
              title = "Ruling Coalition")+
  tm_layout(main.title = "Winning coalitions in state assembly elections, 2019",
            main.title.position = "center",
            main.title.fontface = "bold",
            main.title.size = 1.3,
            frame = FALSE,
            legend.outside = FALSE,
            legend.frame = FALSE,
            legend.position =c("left", "bottom"),
            legend.title.size = 1,
            legend.text.size = 0.8,
            inner.margins = c(0, 0, 0.1 ,0)) + 
  tm_credits("Source: Kay and Vaishnov, 2021")

tmap_save(tmap1, filename = "map1.pdf")


#static to interactive leaflet mode
tmap_mode("view")
tmap_mode("plot")


#GGPLOT
ggmap0 <- ggplot() +
  geom_sf(data = map, aes(fill = bjp_inc_other)) +
  scale_fill_manual(values = group.colors) +
  labs(
    fill = "Coalition", 
    caption = "Source: Kay and Vaishnov, 2021", 
    title = paste("Winning coalitions in state assembly elections, ", "2019")
  )

ggsave("ggmap0.pdf", ggmap0)