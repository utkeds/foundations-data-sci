######################
### W13: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return

#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("stringr")
install.packages("forcats")
install.packages("tidytext")
install.packages("janeaustenr")

library(tidyverse)
library(dplyr)
library(ggplot2)
library(stringr)
library(forcats)
library(tidytext)
library(janeaustenr)

# fct_reorder()
data <- data.frame(
    city = c("New York", "Los Angeles", "Chicago", "Houston", "New York", "Chicago"),
    revenue = c(15000, 22000, 18000, 12000, 13500, 16000))

data <- data %>%
    mutate(city = city %>% fct_reorder(., revenue, sum))
                ## format: fct_reorder(.f, .x, .fun)
    ## Check the levels after reordering
levels(data$city)


# fct_relevel()
data <- data.frame(
    education = c("High School", "Bachelor's", "Some College", "Master's", "High School"))

data <- data %>% 
    mutate(education = fct_relevel(education, "Master's", "Bachelor's", "Some College", "High School"))
            ## format: fct_relevel(.f, ...)
levels(data$education)


# unnest_tokens(): Example 1
text = c(
    "This speech is my recital, I think it's very vital",
    "To rock (a rhyme), that's right (on time)",
    "It's Tricky is the title, here we go..."
)

text


# unnest_tokens(): Example 2
text_df <- tibble(line = 1:3, text = text)
text_df


# unnest_tokens(): Example 3
tidy_df_unnest <- text_df %>%
    unnest_tokens(word, text)


# unnest_tokens(): Example 4
tidy_df_unnest %>%
    head(3)


# stop_words dataset
tidy_df_unnest %>%
    anti_join(stop_words)


# Another example
my_sentences <- tibble(sentences = c("I think that she's really good at playing soccer, 
                                     but he's probably a better dancer, especially at his age", 
                                     "I really like to watch soccer games, especially for OneKnox", 
                                     "She was a great goalkeeper, perhaps because she played soccer from such a young age"))

my_sentences %>% 
    unnest_tokens(word, sentences) %>% # separate words, removing punctuation
    count(word) %>% # counting words
    arrange(desc(n)) %>% # arranging by frequency
    anti_join(stop_words) # removing common words, or "stop" words


################# Code-along ################

# janeaustenr
library(janeaustenr)
library(dplyr)
library(stringr)

original_books <- austen_books() %>%
    group_by(book) %>%
    mutate(linenumber = row_number(), # it counts the lines for each book individually
           chapter = cumsum(str_detect(text, # creates a cumulative sum, which effectively increments the chapter number whenever a new "chapter" line is detected
                                       regex("^chapter [\\divxlc]", # detects lines of text that start with the word "chapter" followed by Roman numerals
                                             ignore_case = TRUE)))) %>% # makes the match case-insensitive
    ungroup() # any subsequent operations applied to original_books will treat it as a regular (ungrouped) data frame


# unnest_tokens()
library(tidytext)

tidy_books <- original_books %>%
    unnest_tokens(word, text)


# Remove stop words
data(stop_words)

tidy_books <- tidy_books %>%
    anti_join(stop_words)


# Count words
tidy_books %>%
    count(word, sort = TRUE)

# Visualize words
library(ggplot2)

tidy_books %>%
    count(word, sort = TRUE) %>% # counts the occurrences of each unique word / the most frequent words appear first
    filter(n > 600) %>% # include only words that appear more than 600 times
    mutate(word = fct_reorder(word, n)) %>% # reorders the levels of the word factor by their frequency (n)
    ggplot(aes(n, word)) + # n: mapped to the x-axis, word: y-axis
    geom_col() + # bar chart where the heights (or lengths) of the bars represent the values of n (word frequencies)
    labs(y = NULL) # removes the y-axis label


