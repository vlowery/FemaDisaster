library(tidyverse)
library(shinydashboard)
library(maps)
library(googleVis)
library(DT)

# Load data
data <- read.csv("./data/database.csv", stringsAsFactors = FALSE)
# Add Year column
data <- data %>% mutate(Year = substr(Declaration.Date, 7, 10))
# Create DF for State Totals Overall
state_count <- data %>% filter(!State %in% c("AS", "FM", "GU", "MH", "MP", "PR", "PW", "VI")) %>% group_by(State) %>% summarise("Total Emergencies" = n())
# Create DT for Disaster Type Totals
data1 <- data %>% group_by("Disaster Type" = Disaster.Type) %>% summarise("Total" = n()) %>% arrange(desc(Total))


