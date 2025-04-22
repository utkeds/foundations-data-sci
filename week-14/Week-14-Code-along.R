######################
### W14: Code along ###
######################

# Install packages
## We have to first install packages before we can load them (with install.packages() then library())
## shortcut: Ctrl + Enter/Cmd + Return

#install.packages("tidyverse")
#install.packages("tidytext")
install.packages("topicmodels")
install.packages("tidyr")

library(tidyverse)
library(tidytext)
library(topicmodels)
library(tidyr)

# AssociatedPress

data("AssociatedPress", package = "topicmodels")
AssociatedPress

# Fitting the model
lda_model <- LDA(AssociatedPress, k = 10, control = list(seed = 1234))
lda_model ## It can take a while

# Topics
topics <- terms(lda_model, 6)
print(topics)

################# Code-along ################

# Loading package and data
    ## install.packages("topicmodels")
library(topicmodels)
data("AssociatedPress")

# LDA()
ap_lda <- LDA(AssociatedPress, k = 2, control = list(seed = 1234))
ap_lda

# Word-topic probabilities
library(tidytext)
ap_topics <- tidy(ap_lda, matrix = "beta")
## In LDA topic modeling, the beta matrix shows how strongly each term (word) is associated with each topic. 
## we are interested in the beta matrix, which represents the probabilities of each term for each topic in the LDA model.
ap_topics

# Finding top terms
library(tidyverse)
ap_top_terms <- ap_topics %>% 
    group_by(topic) %>% 
    slice_max(beta, n = 10) %>% 
    ungroup() %>% 
    arrange(topic, -beta)
    ## slice_max(): Selects the top 10 rows within each group (topic) based on the beta column in descending order.
    ## ungroup(): Removes the grouping created by group_by() so that further operations are performed on the entire data frame, not within groups
    ## arrange(): Sorts the data frame first by topic and then by beta in descending order (-beta). 
    ## This ensures that within each topic, terms are ordered from highest to lowest beta value.
ap_top_terms

ap_top_terms %>% 
    mutate(term = reorder_within(term, beta, topic)) %>% 
    ggplot(aes(beta, term, fill = factor(topic))) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ topic, scale = "free") +
    scale_y_reordered()
    ## reorder_within(term, beta, topic): Reorders terms within each topic based on the beta values.
    ## ggplot(): beta on the x-axis, term on the y-axis, and fill color determined by the topic factor.
    ## geom_col(): Creates bar plots (columns) for each term’s beta value, with the legend for 'fill' turned off.
    ## facet_wrap(): Creates a separate panel (facet) for each topic and allows the axes to be scaled independently.
    ## scale_y_reordered(): Adjusts the y-axis labels to reflect the reordering done. This ensures the terms are displayed correctly within each topic's panel.
