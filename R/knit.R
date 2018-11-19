library(rmarkdown)
library(here)


render(input = here::here("multco-kindergarten-readiness.Rmd"),
     output_file = "index.html")
