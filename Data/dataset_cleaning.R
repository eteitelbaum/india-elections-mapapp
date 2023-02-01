#Data wrangling
library(dplyr)
library(stringr)
library(arrow)

#state elections
coalitions_df <- read_csv("Data/state_coalitions_raw.csv") %>%
  rename(state_name = State_Name,
         year = Year) %>%
  mutate(
    state_name = str_replace_all(state_name, "_", " "), 
    first_four = substr(winning_coalition, 1, 4), 
    bjp_inc_other = case_when(
      first_four == "BJP" ~ "BJP", 
      first_four == "BJP+" ~ "BJP+", 
      first_four == "INC" ~ "INC",
      first_four == "INC(" ~ "INC",
      first_four == "INC+" ~ "INC+", 
      TRUE ~ "Other")) %>% 
      select(state_name, year, bjp_inc_other) # could we keep winning and losing coalition details and include in tooltip?

# write.csv(final_coalitions_df, "state_coalitions.csv", row.names=FALSE)
write_feather(coalitions_df, "state_coalitions.feather")
  

