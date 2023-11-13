library(janeaustenr)
library(dplyr)
library(stringr)
library(ggplot2)
library(tidytext)

honorifics <- c("Mr", "Mrs", "Miss")

original_data <- austen_books() %>% 
    group_by(book) %>% 
    mutate(linenumber = row_number(),
           chapter = cumsum(str_detect(text, regex("^chapter[\\divxlc]", ignore_case = TRUE)))) %>% 
    ungroup()

tidy_books <-
    original_data %>% 
    unnest_tokens(word, text, to_lower = FALSE) %>% 
    mutate(word = case_when(word %in% honorifics ~ word,
                            .default = str_to_lower(word)))

data(stop_words)

tidy_books <-
    tidy_books %>% 
    anti_join(stop_words)

tidy_books %>% 
    count(word, sort = TRUE)

tidy_books %>% 
    count(word, sort = TRUE) %>% 
    filter(n > 600) %>% 
    mutate(word = fct_reorder(word, n)) %>% 
    ggplot(aes(x = n, y = word)) +
    geom_col() +
    labs(y = NULL)
