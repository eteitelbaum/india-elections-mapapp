#Data wrangling
library(tidyverse)

#state elections
coalitions_df <- read_csv("state_level_coalitions_pre_cleaning.csv") %>%
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
      TRUE ~ "Other"))

final_coalitions_df <- coalitions_df %>%
  select(-winning_coalition,-losing_coalition,-first_four)

write.csv(final_coalitions_df, "state_coalitions.csv", row.names=FALSE)