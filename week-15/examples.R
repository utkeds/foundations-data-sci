# mean(is.na(x))
# mean(is.na(y))
# mean(is.na(z))

mean_no_na <- function(number) {
    mean(is.na(number))
}

mean_no_na(c(3, 5, NA, 10))

# x / sum(x, na.rm = TRUE)
# y / sum(y, na.rm = TRUE)
# z / sum(z, na.rm = TRUE)

sum_calc <- function(number) {
    number / sum(number, na.rm = TRUE)
}

sum_calc(4)

# round(x / sum(x, na.rm = TRUE) * 100, 1)
# round(y / sum(y, na.rm = TRUE) * 100, 1)
# round(z / sum(z, na.rm = TRUE) * 100, 1)

round_num <- function(number) {
    round(number / sum(number, na.rm = TRUE) * 100, 1)
}

round_num(30)

for (i in 1:5) {
  print(i)
}




library(purrr)

colors <- c("blue", "green", "red")

my_histograms <- function(dat, x, color, fill, binwidth){
    dat %>%
    ggplot(aes(x = x)) +
    geom_histogram(binwidth = binwidth,
               color = color,
               fill = fill) +
    theme_minimal() +
    labs(x = "Size (in carats)", y = "Number of diamonds")
}

map(colors, ~ my_histograms(diamonds, caret, "white", .x, 0.2))



numbers <- list(1, 2, 3, 4, 5)

squared_numbers <- map(numbers, ~ .x^2)

print(squared_numbers)

