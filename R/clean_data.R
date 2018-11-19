library(tidyverse)
library(here)
library(readxl)
library(janitor)
library(lubridate)
library(tigris)
library(sf)
library(ggmap)
library(tidycensus)

# Districts -----------------------------------------------------------

multco_districts <- read_excel(here::here("data-raw", "oregon-schools.xlsx"),
                               sheet = 2) %>% 
     clean_names() %>% 
     filter(county == "Multnomah") 

# Kindergarten Readiness --------------------------------------------------

var_names_1718 <- c("county",
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



kreadiness_1718 <- read_excel(here::here("data-raw", "k-readiness-1718.xlsx"),
                         skip = 7,
                         col_names = var_names_1718,
                         na = "*") %>% 
     filter(county == "Multnomah") %>% 
     filter(subgroup == "Total Population") %>% 
     filter(institution_type == "School") %>% 
     filter(!is.na(approaches_self_regulation)) %>% 
     select(county:subgroup, 
            approaches_total:math_n,
            literacy_letter_sound:literacy_letter_sound_n) %>% 
     mutate(year = "2017-2018")


var_names_1314 <- c("county",
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
                    "literacy_letters",
                    "literacy_letters_n",
                    "literacy_letter_sound",
                    "literacy_letter_sound_n")


kreadiness_1314 <- read_excel(here::here("data-raw", "k-readiness-1314.xlsx"),
                              skip = 7,
                              col_names = var_names_1314,
                              na = "*") %>% 
     filter(county == "Multnomah") %>% 
     filter(subgroup == "Total Population") %>% 
     filter(institution_type == "School") %>% 
     select(county:subgroup, 
            approaches_total:math_n,
            literacy_letter_sound:literacy_letter_sound_n) %>% 
     mutate(year = "2013-2014")


kreadiness_merged <- bind_rows(kreadiness_1314, kreadiness_1718)

write_csv(kreadiness_merged, here::here("data-clean", "kreadiness-merged.csv"))

# Race/Ethnicity --------------------------------------------


race_ethnicity <- read_excel(here::here("data-raw", "oregon-schools.xlsx"),
                             sheet = 3) %>% 
     clean_names() %>% 
     filter(x2017_18_kindergarten > 0) %>% 
     select(-contains("male")) %>% 
     select(-(x2017_18_kindergarten:x2017_18_grade_twelve)) %>% 
     select(-contains("2016")) %>% 
     filter(district %in% multco_districts$district) %>% 
     rename("institution_id" = "attending_school_institution_id")




# Free and Reduced Lunch --------------------------------------------------

frl <- read_csv(here::here("data-raw", "frl.csv")) %>% 
     clean_names() %>% 
     mutate(date = mdy(schlyr)) %>% 
     mutate(year = year(date)) %>% 
     filter(year == 2017) %>% 
     filter(distnm %in% multco_districts$district) %>% 
     select(distnm, schlnm, schlinstid, freeredlnchpct) %>% 
     set_names(c("district", "school", "institution_id", "frl_pct"))



# Create merged data frame ------------------------------------------------

register_google(key = "AIzaSyBonrLhrEfIT08lG62TA-KOYoaoghonw4Y")

multco_schools <- kreadiness_1718 %>% 
     left_join(frl) %>% 
     left_join(race_ethnicity, by = "institution_id") %>% 
     select(-(attending_district_institution_id:school.y)) %>% 
     select(-(district.x:school.x)) %>% 
     select(-district_id) %>% 
     select(institution_id, dplyr::everything()) %>% 
     rename("school_id" = "institution_id") %>% 
     rename("district" = "district_name") %>% 
     rename("school" = "institution_name") %>%
     mutate(school = case_when(
          school == "Trillium" ~ "Trillium Charter School",
          TRUE ~ school
     )) 



# Geocoding ---------------------------------------------------------------

multco_schools <- multco_schools %>% 
     mutate(location = str_glue("{school}, Multnomah County, Oregon")) %>% 
     mutate_geocode(location) 

# Write to CSV ------------------------------------------------------------

write_csv(multco_schools, here::here("data-clean", "multco-schools.csv"))


# Shapefiles --------------------------------------------------------------

options(tigris_class = "sf")

multco_shapefile <- counties() %>% 
     clean_names() %>% 
     filter(name == "Multnomah")

st_write(multco_shapefile, 
         here::here("data-clean", "multco-shapefile.shp"))


# Shapefiles: Block Groups ------------------------------------------------

options(tigris_use_cache = TRUE)

v15 <- load_variables(2016, "acs5", cache = TRUE)

get_acs()

poverty_shapefile <- get_acs(geography = "tract", 
                   variables = c(rate = "B17020_001"), 
                   state = "OR",
                   cache = T,
                   geometry = T) %>% 
     clean_names() %>% 
     mutate(moe_pct = moe/estimate) %>% 
     filter(str_detect(name, "Multnomah"))


st_write(poverty_shapefile, here::here("data-clean", "poverty-shapefile.shp"))
