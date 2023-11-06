library(educationdata)
library(tidyr)
library(dplyr)
library(ggplot2)
library(tigris)

edu_data <- get_education_data(level = "school-districts",
    source = "ccd",
    topic = "finance",
    filters = list(year = 2018,
                   fips = 47))

tn_districts <- school_districts("Tennessee")

tn_data <-
    left_join(tn_districts, edu_data, join_by(GEOID == leaid))

ggplot(data = tn_data) +
    geom_sf(aes(fill = salaries_total))

salaries_total_by_enrollment <-
    tn_data %>% 
    mutate(salary_by_enrollment = salaries_total/enrollment_fall_school)

ggplot(data = salaries_total_by_enrollment) +
    geom_sf(aes(fill = salary_by_enrollment),
            color = "white") +
    theme_minimal() +
    labs(title = "Total salary amount divided by enrollment",
         fill = "Revenue") +
    scale_fill_continuous(labels = scales::dollar)

tn_data2 <-
    tn_data %>% 
    pivot_longer(-c(STATEFP:censusid, geometry))

tn_data2 %>% 
    filter(name %in% c("salaries_instruction", "salaries_supp_instruc_staff")) %>% 
    ggplot() +
    geom_sf(aes(fill = value)) +
    facet_wrap(~ name)


