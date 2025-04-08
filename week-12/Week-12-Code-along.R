######################
### W12: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return

#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("maps")
#install.packages("mapdata")
install.packages("stringr")
install.packages("sf")
# Per https://github.com/walkerke/tigris, as of April 2025, we should install tigris package using this: 
install.packages("pak")
pak::pak("walkerke/tigris")

library(tidyverse)
library(dplyr)
library(ggplot2)
library(maps)
library(mapdata)

library(stringr)
library(sf)
library(tigris)

# str_trim()
dat <- tibble(txt = c("   Hello  ", "   World   "))
dat %>% mutate(clean_txt = str_trim(txt))

# str_to_lower()
dat <- tibble(txt = c("Tennessee", "tennessee"))
dat %>% mutate(clean_txt = str_to_lower(txt))

# str_replace_all()
dat <- tibble(txt = c("I like apples", "Apples are tasty"))
dat %>% mutate(clean_txt = str_replace_all(txt, "apple", "banana"))

# str_extract()
dat <- tibble(txt = c("Contact me at user@example.com", "Email us at support@email.com"))
dat %>% mutate(emails = str_extract(txt, "\\S+@\\S+"))

# distinct()
dat <- tibble(name = c("Alice", "Bob", "Alice", "Charlie"),
              age = c(25, 30, 25, 28))

distinct(dat)

# drop_na()
dat <- tibble(name = c("Alice", "Bob", NA, "Charlie"),
              age = c(25, NA, 30, 28))

drop_na(dat)

# replace_na()
dat <- tibble(name = c("Alice", "Bob", NA, "Charlie"),
              age = c(25, NA, 30, 28))

dat %>% mutate(age = replace_na(age, 0))


# replace_na() version 2
    ## Replace NA in 'age' with 0 and NA in 'name' with "Unknown"
cleaned_data <- replace_na(dat, list(age = 0, name = "Unknown"))
cleaned_data

# case_when()
dat <- tibble(score = c(85, 72, 95, 60, 78))
dat %>%
    mutate(grade = case_when(score >= 90 ~ "A",
                             score >= 80 ~ "B",
                             score >= 70 ~ "C",
                             TRUE ~ "D"))

# sf storage
    #--- a dataset that comes with the sf package ---#
nc <- st_read(system.file("shape/nc.shp", package = "sf"))

# sf class
class(nc)

# sf geometries
head(nc)

# sf geometries: Ashe County
st_geometry(nc[1, ])[[1]][[1]]

# sf geometries: Plotting
plot(st_geometry(nc[1, ]))

# plotting using geom_sf()
ggplot(data = nc) +
    geom_sf()

# Specifying the aesthetics
library(ggplot2)

ggplot(data = nc) +
    geom_sf(fill = "#0C1337",
            color = "white") +
    theme_void()

# tigris: Downloading data
library(tigris)
  # If the following message comes out, run it: options(tigris_use_cache = TRUE)
tn_districts <- school_districts("Tennessee")

class(tn_districts)

# tigris geometries
tn_districts

# tigris: Plotting geometries
ggplot(tn_districts) + 
    geom_sf()

# Shapefiles: Reading the data
  # In "week-12" folder, you should create "shapefiles" folder, and place the donwloaded shapefile(s).
library(sf)
knox_zones <- st_read("shapefiles/Knoxville-Knox_County_Zoning.shp")

# Shapefiles: Plotting the data
ggplot(data = knox_zones) +
    geom_sf()



################# Code-along ################

# Obtaining the data
library(educationdata)
library(dplyr)
library(tidyr)
library(tigris)
library(ggplot2)

edu_data <- get_education_data(level = "school-districts",
                               source = "ccd",
                               topic = "finance",
                               filters = list(year = 2018,
                                              fips = 47))
  # Documentation: https://educationdata.urban.org/documentation/school-districts.html

# Join the data
tn_districts <- school_districts("Tennessee")
tn_data <-
    left_join(tn_districts, edu_data, join_by(GEOID == leaid))

glimpse(tn_data)

# Plotting the data
ggplot(data = tn_data) + 
    geom_sf(aes(fill = salaries_total))

# Adding to the plot: Creating a new column(variable)
salaries_total_by_enrollment <-
    tn_data %>% 
    mutate(salary_by_enrollment = salaries_total/enrollment_fall_school)
    ## the salary amount per student enrolled in the fall.

# Adding to the plot: ggplot
ggplot(data = salaries_total_by_enrollment) +
    geom_sf(aes(fill = salary_by_enrollment), # each region will be colored based on its salary_by_enrollment value
            color = "white") + # Sets the color of the borders for each region 
    theme_void() + # Removes background elements
    labs(title = "Total salary amount",
         fill = "Revenue") + # Sets the label for the legend
    scale_fill_continuous(labels = scales::dollar) # formats the legend labels as dollar amounts

# Plotting more than one variable: Data structuring
tn_data2 <-
    tn_data %>% 
    pivot_longer(-c(STATEFP:censusid, geometry),
                 names_to = "variables",
                 values_to = "values")
    ## pivot_longer(): to transform data from wide format to long format
    ## then we specified which columns should be kept as they are and not transformed. 
    ## Here, columns STATEFP through censusid, as well as geometry, remain the same, 
    ## while all other columns are "pivoted" into two new columns: variables and values.

# Plotting more than one variable: Plotting
tn_data2 %>% 
    filter(variables %in% c("salaries_instruction", "salaries_supp_instruc_staff")) %>% 
    ggplot() +
    geom_sf(aes(fill = values)) +
    facet_wrap(~ variables)
    ## filter() is used to keep only rows where the name column matches 
    ## either "salaries_instruction" or "salaries_supp_instruc_staff".
    ## fill = value: color of each region will correspond to its value for the selected variables.
    ## facet_wrap() creates separate plots (facets) for each unique value in the name column.
