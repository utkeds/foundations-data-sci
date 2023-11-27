library(topicmodels)
library(tidyverse)
library(tidytext)

data("AssociatedPress")

ap_lda <- LDA(AssociatedPress, k = 2, control = list(seed = 1234))

ap_lda

ap_topics <- tidytext::tidy(ap_lda, matrix = "beta")

ap_top_terms <- ap_topics %>% 
    group_by(topic) %>% 
    slice_max(beta, n = 10) %>% 
    ungroup() %>% 
    arrange(topic, -beta)

ap_top_terms %>% 
    mutate(term = reorder_within(term, beta, topic)) %>% 
    ggplot(aes(beta, term, fill = factor(topic))) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ topic, scale = "free") +
    scale_y_reordered()

beta_wide <- ap_topics %>% 
    mutate(topic = paste0("topic", topic)) %>% 
    pivot_wider(names_from = topic, values_from = beta) %>% 
    filter(topic1 > .001 | topic2 > .001) %>% 
    mutate(log_ratio = log2(topic2 / topic1))
