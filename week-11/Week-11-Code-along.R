######################
### W11: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return

#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("ggplot2")
install.packages("maps")
install.packages("mapdata")

library(tidyverse)
library(dplyr)
library(ggplot2)
library(maps)
library(mapdata)

# Maps data 
world_map <- map_data("world")
head(world_map)

# World map code
ggplot(data = world_map) +
    geom_map(map = world_map,
             aes(x = long,
                 y = lat,
                 map_id = region)) +
    coord_fixed(1.3)

# World map Customization
ggplot(data = world_map) +
    geom_map(map = world_map,
             aes(x = long,
                 y = lat,
                 map_id = region),
             fill = "white", 
             size = 1,
             color = "blue") +
    coord_fixed(1.3)

# World map Customization 2 
ggplot(data = world_map) +
    geom_map(map = world_map,
             aes(x = long,
                 y = lat,
                 map_id = region),
             fill = "orange", 
             size = 0.5,
             color = "purple") +
    coord_fixed(1.3)

# US map
usa_map <- map_data("usa")
ggplot(data = usa_map) +
    geom_map(map = usa_map,
             aes(x = long,
                 y = lat,
                 map_id = region)) +
    coord_fixed(1.3)

# State map
## we should create data first
    ### From map_data, we'll select state parts
state_map <- map_data("state")

    ### Then create a dataset with mock-up values
state_data <-
    state_map %>% 
    select(state = region) %>% 
    distinct() %>% 
    mutate(value = sample(100:1000, n()))

## Plot State map
ggplot(data = state_map) +
    geom_map(map = state_map,
             aes(x = long,
                 y = lat,
                 fill = region, # different color for each state
                 map_id = region)) +
    coord_fixed(1.3) +
    theme(legend.position = "none") # remove the legend


# Filter data
tn_map <-
    state_map %>% 
    filter(region == "tennessee")

## Create ggplot object using filtered data
ggplot(data = tn_map) +
    geom_map(map = tn_map,
             aes(x = long,
                 y = lat,
                 map_id = region)) +
    coord_fixed(1.3) +
    theme(legend.position = "none") # remove the legend

# Making choropleth maps: Global map
head(world_map)

## Create a dataset with mock-up values
regions_data <-
    world_map %>% 
    select(region) %>% 
    distinct() %>% 
    mutate(value = sample(100:1000, n()))

## Joining data
joined_data <- left_join(world_map, regions_data, by = "region")
head(joined_data)

## Create world choropleth map
ggplot(data = joined_data) +
    geom_map(map = joined_data,
             aes(x = long,
                 y = lat,
                 fill = value,
                 map_id = region)) +
    coord_fixed(1.3)

# Making choropleth maps: U.S. Map
head(state_data)
head(state_map)

## Joining data
joined_data <- left_join(
    state_map, state_data, join_by("region" == "state"))

head(joined_data)

## Create USA choropleth map
ggplot(data = joined_data) +
    geom_map(map = joined_data,
             aes(x = long,
                 y = lat,
                 fill = value,
                 map_id = region)) +
    coord_fixed(1.3)


################# Code-along ################

# Pull world map data
world_map <- map_data("world")

# Read in data
bear_dat <- read_csv("bears.csv")
glimpse(bear_dat)

# Prep data
bear_dat_grouped <-
    bear_dat %>% 
    mutate(place_country_name = case_match(place_country_name,
                                           "United States" ~ "USA",
                                           .default = place_country_name)) %>% 
    group_by(place_country_name) %>% 
    summarize(n_bears = n())
    ## case_match() is used for conditional replacement within a column. 
    ## It replaces values in place_country_name based on specified conditions.
    ## "United States" is replaced with "USA" in order to match with the other dataset (usa_map)
    ## For all other values, place_country_name remains unchanged.

# Join data
bear_map <-
    left_join(world_map, bear_dat_grouped, join_by(region == place_country_name))

# Create choropleth data
ggplot(data = bear_map) +
    geom_map(map = bear_map,
             aes(
                 x = long,
                 y = lat,
                 fill = n_bears,
                 map_id = region
             )) +
    coord_fixed(1.3)

# Add points
ggplot(data = bear_map) +
    geom_map(map = bear_map,
             aes(
                 x = long,
                 y = lat,
                 fill = n_bears,
                 map_id = region
             )) +
    coord_fixed(1.3) +
    geom_point(data = bear_dat,
               aes(x = longitude, y = latitude,
                   color = common_name), # different bear species
               alpha = 0.3) + # Sets the transparency of the points to 0.3
    theme(legend.position = "none") # remove the legend

# Add points (with the legend)
ggplot(data = bear_map) +
    geom_map(map = bear_map,
             aes(
                 x = long,
                 y = lat,
                 fill = n_bears,
                 map_id = region
             )) +
    coord_fixed(1.3) +
    geom_point(data = bear_dat,
               aes(x = longitude, y = latitude,
                   color = common_name), # different bear species
               alpha = 0.3) + # Sets the transparency of the points to 0.3
    theme(legend.position = "right") # Add the legent to the right
