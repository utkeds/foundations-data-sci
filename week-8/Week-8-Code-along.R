######################
### W8: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return

#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("palmerpenguins")
library(tidyverse)
library(dplyr)
library(palmerpenguins)

# group_by()
mtcars %>%
    group_by(cyl) %>%
    head()

# group_by(): multiple groups
mtcars %>%
    group_by(cyl, vs) %>%  ## the data is now "grouped" by cyl *and* vs
    head()

# Summarize()
mtcars %>% 
    summarize(mean_mpg = mean(mpg))

############################

# grouping
grouped_data <- penguins %>%
    group_by(species)

grouped_data ## the data is now "grouped" by species (internally)

# Multiple groups
grouped_data_2 <- penguins %>%
    group_by(species, island)

grouped_data_2 ## the data is now "grouped" by species and island (Again, internally)

# Summarize
grouped_data %>% 
    summarize(mean_body_mass_g = mean(body_mass_g))

    ## note: often, we need to add na.rm = TRUE to remove rows with missing values

grouped_data %>% 
    summarize(mean_body_mass_g = mean(body_mass_g, na.rm = TRUE))

    ## can you replace mean with a different measure of central tendency? what do you find?

grouped_data %>% 
    summarize(median_body_mass_g = median(body_mass_g, na.rm = TRUE)) 
                                ## Median is less sensitive to outliers than the mean

grouped_data_2 %>% 
    summarize(mean_body_mass_g = mean(body_mass_g)) 
    ## what is different in this output?

grouped_data_2 %>% 
    summarize(mean_body_mass_g = mean(body_mass_g, na.rm = TRUE)) 
                                                ## na.rm = TRUE: Removing rows with missing values

grouped_data_2 %>% 
    summarize(mean_body_mass_g = mean(body_mass_g),
              max_body_mass_g = max(body_mass_g),
              n = n())
            ## n() is a summary function that returns the number of rows per group

grouped_data_2 %>% 
    summarize(mean_body_mass_g = mean(body_mass_g, na.rm = TRUE),
              max_body_mass_g = max(body_mass_g, na.rm = TRUE),
              n = n())

# Doing more
mean_vals_for_penguins <- penguins %>% 
    group_by(species, island) %>% 
    summarize_if(is.numeric, mean, na.rm = TRUE) 
    ## Summarize_if() applies summary functions only to columns that meet a specified condition
    ## In this case, numeric columns: is.numeric
mean_vals_for_penguins

mean_vals_for_penguins <- penguins %>% 
    group_by(species, island) %>% 
    summarize_if(is.numeric, mean) 
                        ## what if we don't add na.rm = TRUE? try this out!
mean_vals_for_penguins

# And more!
    ## What if we wanted to remove year? We can use select to remove it
mean_vals_for_penguins <- penguins %>% 
    group_by(species, island) %>% 
    summarize_if(is.numeric, mean, na.rm = TRUE) %>% 
    select(-year)  # This removes the 'year' column

mean_vals_for_penguins

    ## OR use summarize_at():
mean_vals_for_penguins <- penguins %>% 
    group_by(species, island) %>% 
    summarize_at(vars(bill_length_mm, bill_depth_mm, flipper_length_mm, 
                      body_mass_g), mean, na.rm = TRUE)
    ## summarize_at() function applies summary functions (in this case, mean) to specific columns.
    ## This allows you to select and summarize only certain variables from your dataset.
mean_vals_for_penguins

