######################
### W7: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return

#install.packages("tidyverse")
#install.packages("dplyr")
library(tidyverse)
library(dplyr)

# Key Concept: dplyr "verbs"
dat <- tibble(
  ID = c(1, 2, 3, 4),
  Name = c("Alice", "Bob", "Charlie", "Stefanie"),
  Age = c(25, 30, 22, 39),
  State = c("TN", "NC", "CA", "TN")
)

dat

# Select(): Retrieve columns based on names
## Format: select(dataframe, column1, column2, ...) OR students %>% select(column1, column2, ...)
selected_data <- dat %>%
  select(Name, Age)

selected_data

## Remove a column using negative sign(-)
selected_data2 <- dat %>%
  select(-State)

selected_data2

# Rename(): Change the column names
## Format: rename(dataframe, new_column_name = old_column_name)
selected_renamed_data <- 
  selected_data %>%
  rename(name = Name, age = Age)

selected_renamed_data

# select and rename in a single step using select():
selected_and_renamed <- 
  dat %>%
  select(name = Name, age = Age) # selects Name and Age and renames them at the same time

selected_and_renamed

# Filter(): Retrieve rows based on conditions
## Format: filter(dataframe, condition)
filtered_data <- dat %>%
  filter(Age >= 25)

filtered_data

filtered_data2 <- dat %>% 
  filter(State == "TN")

filtered_data2

# Arrange(): Sort rows by one or more columns
## Format: dataframe %>% arrange(column1, column2, ...)
arranged_data <- dat %>% 
  arrange(Name)

arranged_data

## reverse the order with desc()
arranged_data <- dat %>% 
  arrange(desc(Name))

arranged_data

# Mutate(): Create or modify columns (variables)
## Format: dataframe %>% mutate(new_column, transformation, ...)
mutated_data <- dat %>%
  mutate(age_next_year = Age + 1)

mutated_data

######################
##### Code-along #####
######################

#install.packages("educationdata")
library(educationdata)

# Accessing
ratio <- get_education_data(level = "college-university",
                            source = "ipeds",
                            topic = "student-faculty-ratio",
                            filters = list(year = 2020))

retention <- get_education_data(level = "college-university",
                                source = "ipeds",
                                topic = "fall-retention",
                                filters = list(year = 2020))

# Preparing
ratio <- as_tibble(ratio)

ratio <- ratio %>% 
  select(unitid, student_faculty_ratio) # to simply the data

retention <- as_tibble(retention)

  ## let's look at the total of both full and part-time students
retention <- retention %>% 
  filter(ftpt == 99) %>% # ftpt: Full-time or part-time status, 99-total
  select(unitid, retention_rate) # to simply the data

# Combining
  ## min_rank(): Assigns the same rank to tied values, but skips ranks after ties (e.g., if two rows have rank 1, the next row will have rank 3).
x <- c(3.5, 4.0, 3.2, 4.0, 3.8)
min_rank(x)
  ## We can see the description of this function: ??min_rank()

combined_data <- inner_join(ratio, retention, by = c("unitid"))

combined_data <- combined_data %>% 
  mutate(student_faculty_ratio_rank = min_rank(student_faculty_ratio),
         retention_rate_rank = min_rank(retention_rate)) %>% 
  select(unitid, student_faculty_ratio_rank, retention_rate_rank)

final_ranks <- combined_data %>% 
  mutate(total_rank = (student_faculty_ratio_rank + retention_rate_rank) / 2) %>% 
  arrange(total_rank) # sort the data by total rank (average rank)

View(final_ranks)

# Interpreting
directory <- get_education_data(level = "college-university",
                                source = "ipeds",
                                topic = "directory",
                                filters = list(year = 2020))

directory <- directory %>% 
  select(unitid, inst_name)

final_ranks_inst <- final_ranks %>% 
  left_join(directory) %>% 
  select(inst_name, total_rank)

View(final_ranks_inst)
