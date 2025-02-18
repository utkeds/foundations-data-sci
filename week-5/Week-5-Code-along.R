######################
### W5: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return

#install.packages("tidyverse")
#install.packages("ggthemes")
#install.packages("dplyr)
library(tidyverse)
library(ggthemes)
library(dplyr)

view(mtcars)

# geom_point
ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_point() # consider swapping out with geom_jitter(); what does this do?

ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_jitter()

# point colors
ggplot(data = mtcars, aes(x = mpg, y = wt, color = cyl)) +
  geom_point()

  ## Continuous color scales: scale_color_gradient()
ggplot(data = mtcars, aes(x = mpg, y = wt, color = cyl)) +
  geom_point() +
  scale_color_gradient(low = "#88CCEE", high = "#D95F02") # You can directly assign custom colors using hexadecimal, RGB, or named colors
  
  ## Categorical color scales: scale_color_brewer()
ggplot(data = mtcars, aes(x = mpg, y = wt, color = factor(cyl))) +
  geom_point() +
  scale_color_brewer(palette = "Set1") 

# geom_smooth()
ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE)

# themes
ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_point() +
  theme_minimal()

ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_point() +
  theme_dark()

ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_point() +
  theme_bw()

# labels
ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_point() +
  labs(title = "MPG vs. Weight",
       x = "Miles per Gallon",
       y = "Weight (1000s lbs)")

# alpha / scale_color_colorblind() / ggsave()
plot <- ggplot(mtcars, aes(x = mpg, y = wt, color = factor(gear))) +
  geom_point(alpha = 0.6) +             # Makes points 60% opaque
  scale_color_colorblind() +            # Use colorblind-friendly palette for categorical data
  theme_minimal() +                     # Use minimal theme for a clean look
  labs(title = "MPG vs Weight by Number of Gears",  
       x = "Miles per Gallon (MPG)",               
       y = "Weight (1000 lbs)",                    
       color = "Number of Gears") 

plot

  ## Save the plot
ggsave("mtcars_plot_gear.png", plot = plot)

#####################################

# Joins
  ## Create the tibbles
x <- tibble(key = c(1, 2, 3), x = c("x1", "x2", "x3"))
y <- tibble(key = c(1, 2, 4), y = c("y1", "y2", "y4"))
y_extra <- tibble(key = c(1, 2, 4, 2), y = c("y1", "y2", "y4", "y5"))

x
y
y_extra

# inner_join()
inner_join(x, y, by = "key")

# left_join()
left_join(x, y, by = "key")

# left_join(): extra rows in y
left_join(x, y_extra, by = "key")

# right_join()
right_join(x, y, by = "key")

# full_join()
full_join(x, y, by = "key")


######## Code-along #######
## We'll use built-in datasets in dplyr as follows: band_members, band_instruments, band_instruments2

# First dataset ("left")
band_members

# Second dataset ("right")
band_instruments

# left_join() - guess which rows will remain!
band_members %>%  
  left_join(band_instruments, by = "name") # This joins the band_members data frame with the band_instruments data frame based on the name column.
  ## A left join ensures that all rows from band_members are retained, regardless of whether there is a matching row in band_instruments.
  ## If there is no matching name in band_instruments, the resulting row from band_members will have NA values for the columns coming from band_instruments.

# right_join()
band_members %>% 
  right_join(band_instruments, by = "name")

# full_join()
band_members %>% 
  full_join(band_instruments,  by = "name")

# different keys
  ## New second dataset ("right")
band_members
band_instruments2

band_members %>% 
  full_join(band_instruments2, by = join_by(name == artist))

  ## equivalent to:
full_join(band_members, band_instruments2, by = join_by(name == artist))

# multiple keys
band_members
band_instruments

  ## what if the Paul in instruments is from another band?
band_instruments_new <- 
  band_instruments %>% 
  mutate(band = c("Beatles", "Porcupines", "Stones")) # The mutate() function is used to add or modify columns in a data frame.

band_instruments_new

  ## we can then join on both name *and* band
band_members
band_instruments_new

band_members %>% 
  left_join(band_instruments_new, by = join_by(name, band)) # both the name and band columns must match in order for rows from the two data frames to be merged.
