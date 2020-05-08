library(tidyverse)
library(shinydashboard)
library(maps)
library(googleVis)
library(DT)
library(lubridate)
library(albersusa)
library(sf)
library(ggthemes)


# Load data
data <- read.csv("./data/DisasterDeclarationsSummaries.csv", stringsAsFactors = FALSE)

# Modify All Date Columns to Date Type, Filter out US Territories, and Remove Duplicates
data <- data %>% mutate(declarationDate = as.Date(declarationDate, "%Y-%m-%d"), 
                               incidentBeginDate = as.Date(incidentBeginDate, "%Y-%m-%d"),
                               incidentEndDate = as.Date(incidentEndDate, "%Y-%m-%d"),
                               disasterCloseoutDate = as.Date(disasterCloseoutDate, "%Y-%m-%d")) %>% 
                rename("State_abbr" = state, "Year" = fyDeclared) %>% 
                filter(!State_abbr %in% c("AS", "FM", "GU", "MH", "MP", "PR", "PW", "VI")) %>% 
                distinct(femaDeclarationString, designatedArea, .keep_all = TRUE)

# Add State Names
state_name_df <- as.data.frame(usa_sf()) %>% select(abbr = iso_3166_2, "State" = name)
data <- left_join(data, state_name_df, by = c("State_abbr" = "abbr"))

# Create DF for State Totals Overall
state_count <- data %>% group_by(State) %>% summarise("Total Emergencies" = length(unique(femaDeclarationString)))

# Create DT for Disaster Type Totals
data_tb <- data %>% group_by("Disaster Type" = incidentType) %>% summarise("Total" = length(unique(femaDeclarationString))) %>% arrange(desc(Total))

# Est. Mean of all Year's Emergency Count
# mean_yearly_emrg <- data %>% filter(Year != 2005, Year != 2020) %>% group_by(Year) %>% summarise(n = n()) %>% summarise(mean(n))


