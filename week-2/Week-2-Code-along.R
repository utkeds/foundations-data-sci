######################
### W2: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return
install.packages("tidyverse")
install.packages("skimr")
library(tidyverse)
library(skimr)

# Set the working directory (Project and File paths)
## create a folder of "Fall2025_STEM 680" --> a folder of "week 2"

# Basic Data structure

## vectors
c(1,2)
c("red", "blue")

## matrices
matrix(c(1, 2, 3, 4), nrow = 2, ncol = 2)

## lists
list("Red", 23)

# Data frames
data.frame(
  Name = c("Alice", "Bob", "Charlie"),
  Age = c(25, 30, 22),
  FavoriteColor = c("Blue", "Red", "Green")
)

# Tibbles
library(tidyverse)
tibble(
  Name = c("Alice", "Bob", "Charlie"),
  Age = c(25, 30, 22),
  FavoriteColor = c("Blue", "Red", "Green")
)

# Functions
add_numbers <- function(x, y) {
  result <- x + y
  return(result)
}

## "Call" the function
add_numbers(5, 3)
add_numbers(100, 30)
add_numbers(5000, 5000)

####################### 
##### Code-along ######
#######################

## built-in data
starwars

## glimpse
glimpse(starwars)

## view
view(starwars)

## skim
#install.packages("skimr")
library(skimr)
skim(starwars)

## %>%
starwars %>% 
  skim()

## <-
starwars2 <- starwars
df <- starwars

# Assignment Prep
## read csv
naep <- read_csv("naep-data.csv")

glimpse(naep)
view(naep) 
# generally recommend not using view() in R Markdown documents 
# (instead, copying and pasting it into the console) 
# as it will cause an error in an R Markdown document
skim(naep)

