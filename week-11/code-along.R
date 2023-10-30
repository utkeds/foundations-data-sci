library(tidyverse)
library(maps)

bear_dat <-
    read_csv(here::here("week-11", "data", "bears.csv"))

world_map <- map_data("world")

bear_dat_grouped <-
    bear_dat %>% 
    mutate(place_country_name = case_match(place_country_name,
                                           "United States" ~ "USA",
                                           .default = place_country_name)) %>% 
    group_by(place_country_name) %>% 
    summarize(n_bears = n())

bear_map <-
    left_join(world_map, bear_dat_grouped, join_by(region == place_country_name))

library(viridis)

ggplot(data = bear_map) +
    geom_map(map = bear_map,
             aes(x = long,
                 y = lat,
                 fill = n_bears,
                 map_id = region),
             linewidth = 0.1,
             color = "white") +
    geom_point(data = bear_dat,
               aes(x = longitude,
                   y = latitude,
                   color = common_name),
               alpha = 0.3,
               size = 0.1) +
    coord_fixed(1.3) +
    labs(title = "Bears around the world") +
    theme_minimal() +
    scale_fill_viridis(option = "magma") +
    theme(legend.position = "none")