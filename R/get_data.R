library(tidyverse)
library(here)


# Kindergarten Readiness Data ---------------------------------------------

# From https://www.oregon.gov/ode/educator-resources/assessment/Pages/Kindergarten-Assessment.aspx

download.file("https://www.oregon.gov/ode/educator-resources/assessment/Documents/KA_Media_1718.xlsx",
              destfile = here::here("data-raw", "k-readiness-1718.xlsx"))

download.file("https://www.oregon.gov/ode/educator-resources/assessment/Documents/oka-results_state-district-school_20140131.xlsx",
              destfile = here::here("data-raw", "k-readiness-1314.xlsx"))



# General Info About Districts --------------------------------------------

download.file("https://www.oregon.gov/ode/reports-and-data/students/Documents/fallmembershipreport_20172018.xlsx",
              destfile = here::here("data-raw", "oregon-schools.xlsx"))


# Free and Reduced Lunch --------------------------------------------------

download.file("https://www.ode.state.or.us/sfda/download/StudentsEligibleforFreeorReducedLunc16.CSV",
              destfile = here::here("data-raw", "frl.csv"))



