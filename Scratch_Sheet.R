library(tidyverse)
library(maps)
library(leaflet)
library(ggplot2)
library(sf)
library(RColorBrewer)
library("rnaturalearth")
library("rnaturalearthdata")
library(googleVis)
library(lubridate)
library(albersusa)
data <- read.csv("./data/database.csv", stringsAsFactors = FALSE)
data <- data %>% mutate(Declaration.Date = as.Date(Declaration.Date, "%m/%d/%Y"), 
                        Start.Date = as.Date(Start.Date, "%m/%d/%Y"),
                        End.Date = as.Date(End.Date, "%m/%d/%Y"),
                        Close.Date = as.Date(Close.Date, "%m/%d/%Y"),
                        Year = format(Declaration.Date, '%Y'))

state_name_df <- as.data.frame(usa_sf()) %>% select(abbr = iso_3166_2, name)
left_join(data, state_name_df, by = c("State" = "abbr"))

head(data)
unique(data$Declaration.Type)

data %>% group_by(State, Year) %>% filter(Disaster.Type=="Fire") %>% tally() #%>% arrange(desc(n))

##### Graph showing the Yearly distribution of Disasters #####
data %>% group_by(Year) %>% tally() %>% arrange(desc(n)) %>% ggplot(aes(x=Year, y=n)) + geom_col(fill="#008080") + ylab("Emergency Count") + ggtitle("Total Emergency Count by Year")
mean_yearly_emrg <- data %>% filter(Year != 2005, Year != 2020) %>% group_by(Year) %>% summarise(n = n()) %>% summarise(mean(n))
##### Graph showing the Yearly distribution of Individual Disasters #####
data %>% group_by(Disaster.Type, Year) %>% tally() %>% ggplot(aes(x=Year, y=n)) + geom_col(aes(fill=Disaster.Type), position="dodge")
data %>% filter(data$Disaster.Type == "Hurricane") %>% group_by(Year) %>% tally() %>% ggplot(aes(x=Year, y=n)) + geom_col(fill = "light blue")
data %>% group_by(Year, Disaster.Type) %>% filter(Disaster.Type %in% c("Storm", "Flood", "Hurricane", "Snow", "Fire", "Ice", "Tornado", "Drought")) %>% 
  tally() %>% arrange(n) %>% ggplot(aes(x=Year, y=n)) + geom_bar(stat="identity", aes(fill=Disaster.Type), position="fill") + scale_fill_brewer(palette="Spectral")

##### Table Showing Top Disaster Types ####
data %>% group_by(Disaster.Type) %>% tally() %>% arrange(desc(n))

##### Map Disaster Count to States ####
state_count <- data %>% group_by(State) %>% tally()

G3 = gvisGeoChart(state_count, 
                  locationvar = "State", 
                  colorvar = "n",
                  options=list(region="US", 
                               displayMode="regions", 
                               resolution="provinces",
                               colors="['#e0d7da', '#c84b4b']",
                               width=800, height=600, titleTextStyle="{color:'red', fontName:'Courier', fontSize:16}"))
plot(G3)

# plot(st_geometry(test_states), col = test_states$Count) + scale_color_continuous(low = "white", high = "red")
tm_shape(test_states) + tm_fill("Count", palette = "-plasma", contrast = c(0.01, 0.7), n = 7, title = "Emergency Totals") + tm_borders()


#####
# mapStates = map("state", fill = TRUE, plot = FALSE)
# leaflet(data = mapStates) %>% addTiles() %>%
#   addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

# data[data$State == "AS", ]
# 
states = map_data("state")
# ggplot(data = states, aes(x = long, y = lat)) +
#   geom_polygon(aes(group = group, fill = group))


# install.packages("usmap")
library(usmap)
# help(usmap)
# 
# library(rgdal)
# states <- readOGR(dsn = "./cb_2014_us_state_20m.shp",
#                   layer = "cb_2014_us_state_20m", verbose = FALSE)

# plot_usmap(include = state_count$State, values = as.numeric(state_count$Count), labels = TRUE) +
#   scale_fill_continuous(low = "white", high = "red", guide = FALSE) +
#   scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0))
# 
#  devtools::install_github("hrbrmstr/albersusa")
# library(albersusa)
# library(leaflet)

# map without background map
leaflet(options = leafletOptions(crs = leafletCRS(crsClass = "L.CRS.Simple"),
                                 minZoom = -13.75)) %>%
  addPolygons(data = geometry)

# with background map (which is of course non-sense)
# leaflet(options = leafletOptions(minZoom = 3, maxZoom = 10)) %>% addTiles() %>% fitBounds(-122, 38, -70, 43) %>%
#   addPolygons(data = my_spatial_data, fillColor = my_spatial_data$n)
# 
# my_spatial_data <- readRDS("myspatialdata.rds")
move_akhi <- usa_sf()
move_akhi$State <- move_akhi$iso_3166_2 # state abbrevation column, AK, AL ...
geometry <- move_akhi[,"State"] # subsetting class sf always retains geometry
my_spatial_data <- merge(x = geometry, y = state_count,
                         by = "State", all.x = TRUE)
#####
head(data)
unique(data$designatedArea)
length(unique(data$declarationRequestNumber))
length(unique(data$femaDeclarationString))
data %>% distinct(femaDeclarationString, designatedArea) %>% group_by(femaDeclarationString, designatedArea) %>% tally() %>% arrange(desc(n))
data %>% distinct(femaDeclarationString, designatedArea) %>% filter(designatedArea == "Statewide") #%>% group_by(Year) %>% select(Year, incidentType) %>% arrange(desc(Year))#%>% tally()
data <- data %>% distinct(femaDeclarationString, designatedArea)

length(unique(data$declarationDate))
#####

data %>% filter(data$incidentType == "Tornado") %>% group_by(Year) %>% 
  summarise(Count = length(unique(femaDeclarationString))) %>% ggplot(aes(x=Year, y=Count)) + geom_col(fill = "#2f3337") + 
  scale_x_continuous(breaks=seq(1950, 2020, 2)) + geom_smooth(colour = "red", se= FALSE) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))





