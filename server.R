

function(input, output, session){
  
  output$totals_yearly <- renderPlot(
    data %>% group_by(Year) %>% summarise(Total = length(unique(femaDeclarationString))) %>% 
      ggplot(aes(x=Year, y=Total)) + 
      geom_col(aes(fill=ifelse(Year == 1996|Year == 2011|Year==2020, "#008080", "#ce412a"))) + 
      ylab("Emergency Count") + ggtitle("Total Emergency Count by Disaster ID") + theme(legend.position = "none") + 
      geom_text(aes(label = ifelse(Year == 1996|Year == 2011|Year==2020, Total, "")),  vjust = -0.5) +
      scale_x_continuous(breaks=seq(1950, max(data$Year), 5))
  )
  
  output$reframe <- renderPlot(
    data %>% group_by(Year) %>% summarise(Count = n()) %>% ggplot(aes(x=Year, y=Count)) + 
      geom_col(aes(fill=ifelse(Year == 2005|Year==2020, "#008080", "#ce412a"))) + 
      ylab("Emergency Count") + ggtitle("Total Emergency Count by Counties Affected") + 
      theme(legend.position = "none") + geom_text(aes(label = ifelse(Year == 2005|Year==2020, Count, "")),  vjust = -0.5) +
      scale_x_continuous(breaks=seq(1950, max(data$Year), 5))
  )
  
  output$text1 <- renderText(
    paste("Reactive Bar Graph and Map:", input$radio1)
  )
  
  output$pie_1996 <- renderGvis(
    data %>% filter(Year == 1996) %>% group_by(incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      gvisPieChart(labelvar = "incidentType", numvar = "Count", 
                   options=list(width="450px", height="400px", 
                                title = "Proportions of Emergencies, 1996",
                                chartArea= "{left:40, top:30, bottom:0, right:0}", 
                                #slices="[{}, {offset: .2}, {}, {}, {}, {offset: .2}, {}]", 
                                colors="['#ce412a', '#001489', '#c69c6e', '#ffc2cd', '#008080', '#dbe7ff', '#00ffff']"))
  )
  
  output$map_1996 <- renderPlot(
    data %>% filter(Year == 1996) %>% group_by(State, incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      left_join(., polygon_df, by = c("State")) %>% st_sf() %>% 
      tm_shape() + tm_fill("Count", palette = "YlGnBu", contrast = c(0.01, 1), title = "Emergency Totals") + tm_borders()
  )
  
  output$map_2011 <- renderPlot(
    data %>% filter(Year == 2011) %>% group_by(State, incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      left_join(., polygon_df, by = c("State")) %>% st_sf() %>% 
      tm_shape() + tm_fill("Count", palette = "YlGnBu", contrast = c(0.01, 1), title = "Emergency Totals") + tm_borders()
  )
  
  output$pie_2011 <- renderGvis(
    data %>% filter(Year == 2011) %>% group_by(incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      gvisPieChart(labelvar = "incidentType", numvar = "Count", 
                   options=list(width="450px", height="400px", 
                                title = "Proportions of Emergencies, 2011",
                                chartArea= "{left:40, top:30, bottom:0, right:0}", 
                                #slices="[{}, {offset: .2}, {}, {}, {}, {offset: .2}, {offset: .3}]", 
                                colors="['#ffc2cd', '#c69c6e', '#ce412a', '#001489', '#008080', '#dbe7ff', '#00ffff']"))
  )
  
  output$map_2020 <- renderPlot(
    data %>% filter(Year == 2020) %>% group_by(State, incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      left_join(., polygon_df, by = c("State")) %>% st_sf() %>% 
      tm_shape() + tm_fill("Count", palette = "YlGnBu", contrast = c(0.01, 1), title = "Emergency Totals") + tm_borders()
  )
  
  output$pie_2020 <- renderGvis(
    data %>% filter(Year == 2020) %>% group_by(incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      gvisPieChart(labelvar = "incidentType", numvar = "Count", 
                   options=list(width="450px", height="400px", 
                                title = "Proportions of Emergencies, 2020",
                                chartArea= "{left:40, top:30, bottom:0, right:0}", 
                                slices="[{}, {offset: .3}, {offset: .2}, {offset: .4}, {offset: .4}, {offset: .4}, {offset: .4}]", 
                                colors="['#808000', '#ce412a', '#c69c6e', '#001489', '#008080', '#00ffff', '#effd5f']"))
  )
  
  output$totals_map <- renderGvis(
    gvisGeoChart(state_count, 
                 locationvar = "State", 
                 colorvar = "Count",
                 options=list(region="US", displayMode="regions", resolution="provinces", width="auto", height="auto",
                              colors="['#e0d7da', '#c84b4b']"))
  )
  
  output$totals_table <- renderDataTable(
    datatable(state_count) %>% 
      formatStyle("Count", background = styleColorBar(state_count$Count, '#c84b4b'), 
                  backgroundSize = '100% 90%', backgroundRepeat = 'no-repeat', backgroundPosition = 'center')
  )
  
  output$five_states <- renderPlot(
    data %>% filter(State == "Texas"|State == "Florida"|State == "California"|State == "Washington"|State == "Oklahoma") %>% 
      group_by(State, incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      ggplot(aes(x=reorder(incidentType, Count, max), y=Count)) + geom_col(aes(fill = State)) + 
      labs(title="Emergency Distribution, 1953-2020", x = "Emergency Type") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + theme(legend.position = "none") +
      scale_fill_manual(values = c("#f29591", "#486bea", "#e5d2d1", "#d6a23b", "#152596")) + ylim(c(0, 300)) +
      geom_text(aes(label = ifelse(incidentType == "Severe Storm(s)"|incidentType == "Hurricane"|incidentType == "Fire", Count, "")),  hjust = 0.4, vjust = -0.5) + facet_grid(State ~ .)
  )
  
  output$disaster_chart <- renderPlot(
    data %>% filter(data$incidentType == input$radio1) %>% group_by(Year) %>% 
      summarise(Count = length(unique(femaDeclarationString))) %>% ggplot(aes(x=Year, y=Count)) + geom_col(fill = "#2f3337") + 
      scale_x_continuous(limits = c(1952, 2021), n.breaks = 14) + #breaks=seq(1950, 2020, 2)) + 
      #xlim(1953, 2021) + 
      geom_smooth(color = "red", se= FALSE, ymin = 0) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  )
  
  output$disaster_map <- renderGvis(
    data %>% filter(data$incidentType == input$radio1) %>% group_by(State) %>% 
      summarise(Count = length(unique(femaDeclarationString))) %>% 
      gvisGeoChart(locationvar = "State", 
                   colorvar = "Count",
                   options=list(region="US", displayMode="regions", resolution="provinces", width="auto", height="auto",
                                backgroundColor = "#dbe7ff", colors="['#ffd5e1', '#7c009c']"))
  )
  
  output$disasters_table <- renderDataTable(
    datatable(data_tb) %>% formatStyle("Total", background = styleColorBar(data_tb$Total, '#b82b4b'),
                  backgroundSize = '100% 90%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center')
  )
  
  output$delay_graph <- renderPlot(
    data %>% mutate("Delay" = declarationDate - incidentBeginDate) %>%
      filter(Delay >= 0) %>% distinct(femaDeclarationString, declarationDate, Year, incidentType, 
                                        declarationTitle, incidentBeginDate, incidentEndDate, State, Delay = as.numeric(gsub(" days", "", Delay))) %>% 
      ggplot(aes(x=Year, y=Delay)) + geom_point()
  )
  
  output$longest_disaster <- DT::renderDataTable(
    table_longest %>% datatable(options = list(dom = 't', autoWidth = TRUE)) %>% 
      formatStyle("Duration (days)", background = styleColorBar(table_longest$`Duration (days)`, '#b82b4b'))
      )
  
  output$drought_fire <- renderPlot(
    data %>% filter(incidentType != "Biological", incidentType != "Other", incidentType != "Terrorist", 
                      incidentType != "Typhoon", incidentType != "Chemical", incidentType != "Human Cause") %>% 
      group_by(incidentType, Year) %>% 
      summarise(Count = length(unique(femaDeclarationString))) %>% 
      pivot_wider(names_from = incidentType, values_from = Count, values_fill = list(Count = 0)) %>% cor() %>% 
      ggcorrplot(outline.col = "white")
  )
  
}
