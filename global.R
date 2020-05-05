library(tidyverse)
library(shinydashboard)

# Load data
data <- read.csv("./data/database.csv", stringsAsFactors = FALSE)
# Add Year column
data <- data %>% mutate(Year = substr(Declaration.Date, 7, 10))


