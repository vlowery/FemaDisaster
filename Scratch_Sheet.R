library(tidyverse)
data <- read.csv("database.csv", stringsAsFactors = FALSE)
data <- data %>% mutate(Year = substr(Declaration.Date, 7, 10))
head(data)
unique(data$Declaration.Type)

data %>% mutate(Year = substr(Declaration.Date, 7, 10)) %>% group_by(State, Year) %>% filter(Disaster.Type=="Fire") %>% tally() #%>% arrange(desc(n))

##### Graph showing the Yearly distribution of Disasters #####
data %>% group_by(Year) %>% tally() %>% arrange(desc(n)) %>% ggplot(aes(x=Year, y=n)) + geom_col()
##### Graph showing the Yearly distribution of Individual Disasters #####
data %>% group_by(Disaster.Type, Year) %>% tally() %>% ggplot(aes(x=Year, y=n)) + geom_col(aes(fill=Disaster.Type), position="dodge")
##### 