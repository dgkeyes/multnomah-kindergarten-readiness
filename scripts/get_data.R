library(tidyverse)
library(here)


# Kindergarten Readiness Data ---------------------------------------------

# From https://www.oregon.gov/ode/educator-resources/assessment/Pages/Kindergarten-Assessment.aspx

download.file("https://www.oregon.gov/ode/educator-resources/assessment/Documents/KA_Media_1718.xlsx",
              destfile = here("data-raw", "k-readiness.xlsx"))


