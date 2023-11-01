# install.packages("zoomGroupStats")
library(zoomGroupStats)
library(tidyverse)
# install.packages("randomNames")
# library(randomNames) # if desired

transcript <- read_lines("data/zoom/GMT20230925-160316_Recording.transcript.vtt")

big_list <- transcript[3:length(transcript)] %>% 
    as_tibble() %>% 
    mutate(new_var = rep(c("index", "timestamp", "name and text", "blank"), 463)) %>% 
    filter(new_var != "blank") %>% 
    pivot_wider(names_from = "new_var", values_from = "value")

transcript <- tibble(index = unlist(big_list[1]), timestamp = unlist(big_list[2]), name_text = unlist(big_list[3]))

transcript <- transcript %>% 
    separate(name_text, into = c("name", "text"), sep = ":") 

transcript <- transcript %>% 
    mutate(text = str_trim(text),
           name = str_trim(name))

transcript <- transcript %>% 
    separate(timestamp, into = c("start", "end"), sep = "-->") %>% 
    mutate(start = str_trim(start),
           end = str_trim(end))

transcript %>% 
    write_csv("data/zoom/processed-transcript.csv")
