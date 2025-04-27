######################
### W15: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return

#install.packages("tidyverse")
library(tidyverse)

# Function 1
    # mean(is.na(x))
    # mean(is.na(y))
    # mean(is.na(z))

    # calculates the proportion of missing values in a vector
    # Internally, FALSE is treated as 0 and TRUE as 1.

avg_missing <- function(number) {
    mean(is.na(number))
}

avg_missing(c(3, 5, NA, 10))


# Function 2
    # x / sum(x, na.rm = TRUE)
    # y / sum(y, na.rm = TRUE)
    # z / sum(z, na.rm = TRUE)

    # Proportion Normalization 
    # Scales values relative to their total sum so they represent proportions

prop_normalize <- function(number) {
    number / sum(number, na.rm = TRUE)
}

prop_normalize(c(2, 2, 6))


# Function 3
    # round(x / sum(x, na.rm = TRUE) * 100, 1)
    # round(y / sum(y, na.rm = TRUE) * 100, 1)
    # round(z / sum(z, na.rm = TRUE) * 100, 1)

    # Percentages with Rounding
    # Computes percentages of proportional normalization values, rounds the result to one decimal place, and ignores missing values

prop_normalize_percentage <- function(number) {
    round(number / sum(number, na.rm = TRUE) * 100, 1)
}

prop_normalize_percentage(c(2, 2, 6))


# Function 4 
my_histograms <- function(dat, x, color, fill, binwidth){
    dat %>%
        ggplot(aes(x = x)) +
        geom_histogram(binwidth = binwidth,
                       color = color,
                       fill = fill) +
        theme_minimal() +
        labs(x = "Size (in carats)", y = "Number of diamonds")
}

my_histograms(diamonds, carat, "black", "yellow", 0.5)


# Loop 1
for (i in 1:5) {
    print(i)
}


# Loop 2
    # my_histograms(diamonds, carat, "white", "blue", 0.2)
    # my_histograms(diamonds, carat, "white", "green", 0.2)
    # my_histograms(diamonds, carat, "white", "red", 0.2)

colors <- c("blue", "green", "red")

for (color in colors) {
    print(my_histograms(diamonds, carat, "white", color, 0.2))
}
