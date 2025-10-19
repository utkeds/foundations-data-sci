######################
### W10: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return

#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("ggplot2")
library(tidyverse)
library(dplyr)
library(ggplot2)

# Pivot_longer()
dat <- tibble(name = c("Maryrose", "Isabella"),
              observation_at_t1 = c(3, 2),
              observation_at_t2 = c(5, 1),
              observation_at_t3 = c(3, 5))

dat

dat %>% 
  pivot_longer(!name, names_to = "time", values_to = "values")
  # we use ! to indicate which columns should not be pivoted

# Pivot_wider()
dat_long <- dat %>% 
  pivot_longer(!name, names_to = "time", values_to = "values")

dat_long %>% 
  pivot_wider(names_from = time, values_from = values)

dat_long

# Pivot_longer()
dat2 <- tibble(
  person = c("John", "Sarah", "Tom"),
  math_score = c(80, 95, 88),
  science_score = c(90, 85, 92),
  history_score = c(75, 90, 85)
)

dat2

dat2_long <- dat2 %>%
  pivot_longer(
    cols = !person,                 # Pivot the score columns
    names_to = "subject",           # New column to store subject names
    values_to = "score"             # New column to store the scores
  )

dat2_long

# Pivot_wider()
dat2_wide_again <- dat2_long %>%
  pivot_wider(
    names_from = subject,           # New columns will be created based on the 'subject' column
    values_from = score             # The 'score' column will fill in the values
  )

dat2_wide_again

# More practice
View(relig_income) ## pre-built dataset in the ggplot2

  ## Please take a moment to think about how to set pivot_longer(). 


































# Pivot_longer
relig_income_long <- relig_income %>%
  pivot_longer(
    cols = !religion,            # Do not pivot the 'religion' column
    names_to = "income_range",  # New column for income range
    values_to = "count"           # New column for the counts
  )

View(relig_income_long)

# pivot_wider
## Convert back to wide format using pivot_wider
relig_income_wide <- relig_income_long %>%
  pivot_wider(
    names_from = income_range,  # The 'income_bracket' column will become new column names
    values_from = count           # The 'count' column will fill in the values
  )

# View the reverted wide-format data
View(relig_income_wide)

