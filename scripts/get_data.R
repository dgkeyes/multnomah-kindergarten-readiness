library(tidyverse)
library(here)


# Kindergarten Readiness Data ---------------------------------------------

# From https://www.oregon.gov/ode/educator-resources/assessment/Pages/Kindergarten-Assessment.aspx

download.file("https://www.oregon.gov/ode/educator-resources/assessment/Documents/KA_Media_1718.xlsx",
              destfile = here("data-raw", "k-readiness.xlsx"))



# General Info About Districts --------------------------------------------

# https://www.ode.state.or.us/instID/

# download.file("https://www.ode.state.or.us/ftp/incoming/inst_db_extract_XL8.zip",
#               destfile = here("data-raw", "oregon-schools.zip"))
# 
# unzip(here("data-raw", "oregon-schools.zip"),
#       exdir = "data-raw")
# 
# file.rename(from = here("data-raw", "Inst_Db_Extract_xl8.xls"),
#             to = here("data-raw", "oregon-schools-general.xls"))
# 
# file.remove(here("data-raw", "oregon-schools.zip"))
# 
# convert(here("data-raw", "oregon-schools-general.xls"),
#         here("data-raw", "oregon-schools-general.csv"))

# General Info About Districts --------------------------------------------

download.file("https://www.oregon.gov/ode/reports-and-data/students/Documents/fallmembershipreport_20172018.xlsx",
              destfile = here("data-raw", "oregon-schools.xlsx"))



