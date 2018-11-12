library(tidyverse)
library(here)
library(readxl)
library(tigris)
library(janitor)
library(rio)


# Kindergarten Readiness --------------------------------------------------



var_names <- c("county",
               "district_id",
               "district_name",
               "institution_id",
               "institution_name",
               "institution_type",
               "subgroup_type",
               "subgroup",
               "approaches_self_regulation",
               "approaches_interpersonal_skills",
               "approaches_total",
               "approaches_n",
               "math_number",
               "math_n",
               "literacy_uppercase_letters",
               "literacy_uppercase_letters_n",
               "literacy_lowercase_letters",
               "literacy_lowercase_letters_n",
               "literacy_letter_sound",
               "literacy_letter_sound_n")



kreadiness <- read_excel(here("data-raw", "k-readiness.xlsx"),
                         skip = 7,
                         col_names = var_names,
                         na = "*") %>% 
     filter(county == "Multnomah")




# General Info About Schools --------------------------------------------


multco_districts <- read_excel(here("data-raw", "oregon-schools.xlsx"),
                            sheet = 2) %>% 
     clean_names() %>% 
     filter(county == "Multnomah")


multco_schools <- read_excel(here("data-raw", "oregon-schools.xlsx"),
                             sheet = 3) %>% 
     clean_names() %>% 
     filter(district %in% multco_districts$district) %>% 
     filter(x2017_18_kindergarten > 0)



# School District Shapefiles ----------------------------------------------


