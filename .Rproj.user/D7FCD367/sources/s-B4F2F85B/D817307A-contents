library(tidyverse)
library(maps)
library(leaflet)
library(ggplot2)
library(sf)
library(RColorBrewer)
library("rnaturalearth")
library("rnaturalearthdata")
library(googleVis)
data <- read.csv("./data/database.csv", stringsAsFactors = FALSE)
data <- data %>% mutate(Year = substr(Declaration.Date, 7, 10))

head(data)
unique(data$Declaration.Type)

data %>% mutate(Year = substr(Declaration.Date, 7, 10)) %>% group_by(State, Year) %>% filter(Disaster.Type=="Fire") %>% tally() #%>% arrange(desc(n))

##### Graph showing the Yearly distribution of Disasters #####
data %>% group_by(Year) %>% tally() %>% arrange(desc(n)) %>% ggplot(aes(x=Year, y=n)) + geom_col()

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
#####
# mapStates = map("state", fill = TRUE, plot = FALSE)
# leaflet(data = mapStates) %>% addTiles() %>%
#   addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

# data[data$State == "AS", ]
# 
# states = map_data("state")
# ggplot(data = states, aes(x = long, y = lat)) +
#   geom_polygon(aes(group = group, fill = group))


# install.packages("usmap")
# library(usmap)
# help(usmap)
# 
# library(rgdal)
# states <- readOGR(dsn = "./cb_2014_us_state_20m.shp",
#                   layer = "cb_2014_us_state_20m", verbose = FALSE)

# plot_usmap(data = state_count, values = "n", labels = TRUE) + 
#   scale_fill_continuous(low = "white", high = "red", guide = FALSE) + 
#   scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0))
# 
# 
#  devtools::install_github("hrbrmstr/albersusa")
# library(albersusa)
# library(leaflet)

# map without background map
# leaflet(options = leafletOptions(crs = leafletCRS(crsClass = "L.CRS.Simple"),
#                                  minZoom = -100)) %>%
#   addPolygons(data = usa_sf("lcc"))

# with background map (which is of course non-sense)
# leaflet(options = leafletOptions(minZoom = 3, maxZoom = 10)) %>% fitBounds(-122, 38, -70, 43) %>%
#   addPolygons(data = my_spatial_data, fillColor = my_spatial_data$n)
# 
# my_spatial_data <- readRDS("myspatialdata.rds")
# move_akhi <- usa_sf()
# move_akhi$State <- move_akhi$iso_3166_2 # state abbrevation column, AK, AL ...  
# geometry <- move_akhi[,"State"] # subsetting class sf always retains geometry 
# my_spatial_data <- merge(x = geometry, y = state_count, 
#                          by = "State", all.x = TRUE)
#####



#####




