library(tidyverse)
library(shinydashboard)
library(maps)
library(googleVis)
library(DT)
library(lubridate)
library(albersusa)
library(ggthemes)
# library(tmap)
library(ggcorrplot)
# library(magick)

# Load data
data <- read.csv("./data/DisasterDeclarationsSummaries.csv", stringsAsFactors = FALSE)

# Modify All Date Columns to Date Type, Manually add in Years (csv incorrect with most 2000 logged as 2001), Filter out US Territories, and Remove Duplicates
data <- data %>% mutate(declarationDate = as.Date(declarationDate, "%Y-%m-%d"), 
                               incidentBeginDate = as.Date(incidentBeginDate, "%Y-%m-%d"),
                               incidentEndDate = as.Date(incidentEndDate, "%Y-%m-%d"),
                               disasterCloseoutDate = as.Date(disasterCloseoutDate, "%Y-%m-%d")) %>% 
                rename("State_abbr" = state, "Year" = fyDeclared) %>% 
                mutate(Year = year(incidentBeginDate)) %>% 
                filter(!State_abbr %in% c("AS", "FM", "GU", "MH", "MP", "PR", "PW", "VI")) %>% 
                distinct(femaDeclarationString, designatedArea, .keep_all = TRUE) %>% 
                select(-hash, -lastRefresh, -id)

# Add State Names
state_name_df <- as.data.frame(usa_sf()) %>% select(abbr = iso_3166_2, "State" = name)
data <- left_join(data, state_name_df, by = c("State_abbr" = "abbr"))

# Create DF for State Totals Overall
state_count <- data %>% group_by(State) %>% summarise("Count" = length(unique(femaDeclarationString))) %>%
  mutate("Percentage of Total" = paste0(round(100*Count/sum(Count), 1), "%")) %>% select(1, 3, 2)

# Create DT for Disaster Type Totals
data_tb <- data %>% group_by("Disaster Type" = incidentType) %>% summarise("Total" = length(unique(femaDeclarationString))) %>% arrange(desc(Total))

# Est. Mean of all Year's Emergency Count
mean_yearly_emrg <- data %>% filter(Year != 2005, Year != 2020, Year != 1996) %>% group_by(Year) %>% 
  summarise(n = length(unique(femaDeclarationString))) %>% summarise(mean(n))

# Create Table for Longest Disaster
table_longest <- data %>% mutate("Duration" = as.integer(incidentEndDate - incidentBeginDate)) %>% arrange(desc(Duration)) %>% 
  group_by(femaDeclarationString) %>% distinct(femaDeclarationString, .keep_all = TRUE) %>% 
  select("FEMA Disaster ID" = femaDeclarationString, State, Year, "Duration (days)" = Duration, "Incident Start Date" = incidentBeginDate, "Incident End Date" = incidentEndDate, "Incident Type" = incidentType, "Incident Title" = declarationTitle) %>% 
  head(10)

# Create fips DF for Leaflet Maps
# polygon_df <- usa_sf() %>% select(fips_state, "State" = name, geometry)

 
# # CREATE ANIMATION
# # 1. Create Function to be able to add year tallies as each year passes
# sum_years <- function(year_vector){
#   for (i in 2:length(year_vector)){
#     year_vector[i] = year_vector[i] + year_vector[i-1]
#   }
#   return(year_vector)
# }
# # 2. Create a blank df accounting for every state for every year, since some years not all states had emergencies
# tallies_df <- data.frame(Years = rep(unique(year_count$Year), each = 51), States = unique(year_count$State), Count = 0, stringsAsFactors = FALSE)
# 
# # 3. Filter for every unique emergency, spread that against the tallies_df, replace empty years with 0, apply function to Counts
# year_count <- data %>% group_by(Year, State) %>% summarise(Count = length(unique(femaDeclarationString))) %>%
#   right_join(., tallies_df, by=c("Year" = "Years", "State" = "States")) %>%
#   mutate(Count = ifelse(is.na(Count.x), Count.y, Count.x)) %>% select(-Count.x, -Count.y) %>%
#   group_by(State) %>% arrange(Year) %>%  mutate(Count = sum_years(Count)) %>% ungroup() %>%
#   left_join(., polygon_df, by = c("State")) %>% st_sf() %>% ungroup()
# 
# # 4. Create shape file of US States
# country_shape <- data %>% select(State) %>% unique() %>% left_join(., polygon_df, by = c("State")) %>% st_sf()
# 
# # 5. Create the animation maps
# year_anim <- tm_shape(country_shape) + tm_polygons() + tm_shape(year_count) +
#   tm_dots(size = "Count", col = 'red', alpha = .5) +
#   tm_facets(along = "Year", free.coords = FALSE)
# 
# # 6. Output .gif
# tmap_animation(tm = year_anim, filename = "year_anim.gif", width = 1000, height = 700, delay=19)




# To accomodate emergencies labeled as "Statewide" being weighted only once
county_count <- data.frame("Count" = c(254, 159, 133, 120, 115, 105, 102, 100, 99, 95, 93, 92, 88, 87, 83, 82, 
                                       77, 75, 72, 67, 67, 67, 66, 64, 64, 62, 58, 56, 55, 53, 46, 44,
                                       39, 36, 33, 29, 29, 24, 23, 21, 17, 16, 15, 14, 14, 10, 8, 5, 5, 3),
                           "State" = c("Texas", "Georgia", "Virginia", "Kentucky", "Missouri", "Kansas",
                                        "Illinois", "North Carolina", "Iowa", "Tennessee", "Nebraska",  "Indiana", "Ohio", "Minnesota", "Michigan", "Mississippi",
                                        "Oklahoma", "Arkansas", "Wisconsin", "Alabama", "Florida", "Pennsylvania", "South Dakota", "Colorado", "Louisiana", "New York",
                                        "California", "Montana", "West Virginia", "North Dakota", "South Carolina", "Idaho", "Washington", "Oregon", "New Mexico", "Alaska",
                                        "Utah", "Maryland", "Wyoming", "New Jersey", "Nevada", "Maine", "Arizona", "Massachusetts", "Vermont", "New Hampshire", "Connecticut",
                                        "Hawaii", "Rhode Island", "Delaware"))





