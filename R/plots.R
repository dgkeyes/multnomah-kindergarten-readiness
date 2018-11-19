library(tidyverse)
library(here)
library(janitor)
library(sf)


# Get Data ----------------------------------------------------------------

kreadiness <- read_csv(here::here("data-clean", "kreadiness-merged.csv")) %>% 
     rename("school_id" = "institution_id") %>% 
     add_count(school_id) %>% 
     filter(n == 2)

multco_schools <- read_csv(here::here("data-clean", "multco-schools.csv")) %>% 
     st_as_sf(coords = c("lon", "lat"),
              crs = 4326) %>% 
     select(school_id:school)

multco_schools <- merge(multco_schools, kreadiness)


# Plots -------------------------------------------------------------------

approaches <- kreadiness %>% 
     select(school_id, approaches_total, year) %>% 
     spread(year, approaches_total) %>% 
     mutate(change = `2017-2018` - `2013-2014`) %>% 
     filter(!is.na(change)) %>% 
     mutate(school_id = as.character(school_id)) %>% 
     gather(year, approaches_total, -c(school_id, change))


ggplot() +
     geom_point(data = filter(approaches, year == "2013-2014"), 
                              aes(school_id, approaches_total,
                                group = school_id),
                color = "orange") +
     geom_point(data = filter(approaches, year == "2017-2018"), 
                aes(school_id, approaches_total,
                    group = school_id),
                color = "blue") +
     geom_line(data = approaches, aes(school_id, approaches_total,
                               group = school_id)) +
     coord_flip()

     geom_line() +
     theme_void() +
     theme(legend.position = "none") +
     scale_colour_gradient(low = "red", high = "blue")
