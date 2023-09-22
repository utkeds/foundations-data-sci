mtcars %>% 
    ggplot(aes(x = as.factor(cyl), y = mpg)) +
    geom_bar(stat = "identity")

mtcars %>% 
    ggplot(aes(x = as.factor(cyl), y = mpg, fill = as.factor(cyl))) +
    geom_bar(stat = "identity")

# by adding a new variable

mtcars %>% 
    mutate(cyl_2 = case_when(cyl == 4 ~ "y",
                             .default = "n")) %>% 
    ggplot(aes(x = as.factor(cyl), y = mpg, fill = cyl_2)) +
    geom_bar(stat = "identity")

# by manually specifying colors

mtcars %>% 
    ggplot(aes(x = as.factor(cyl), y = mpg, fill = as.factor(cyl))) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = c("4" = "#6688F7", 
                                 "6" = "#6688F7", 
                                 "8" = "#F4AC00"))
