

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
    data %>% group_by(Year, State, designatedArea) %>% summarise(Tally = n()) %>% left_join(., county_count) %>% 
      mutate(Tally = ifelse(designatedArea == "Statewide", Count, Tally)) %>% group_by(Year) %>% summarise(Count = n()) %>% 
      ggplot(aes(x=Year, y=Count)) + 
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
                   options=list(width="400px", height="350px", 
                                title = "Proportions of Emergencies, 1996",
                                chartArea= "{left:40, top:30, bottom:0, right:0}", 
                                colors="['#ce412a', '#001489', '#c69c6e', '#ffc2cd', '#008080', '#dbe7ff', '#00ffff']"))
  )
  
  output$map_1996 <- renderGvis(
    data %>% filter(Year == 1996) %>% group_by(State, incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      gvisGeoChart(locationvar = "State", colorvar = "Count", 
                   options = list(region="US", displayMode="regions", 
                                  resolution="provinces", width="auto", height="auto", 
                                  backgroundColor = "#dbe7ff", colors="['#e0d7da', '#c84b4b']"))
    # left_join(., polygon_df, by = c("State")) %>% st_sf() %>% 
    # tm_shape() + tm_fill("Count", palette = "Reds", contrast = c(0.2, 0.9), title = "Emergency Totals") + tm_borders() + tm_shape(country_shape) + tm_borders()
  )
  
  output$map_2011 <- renderGvis(
    data %>% filter(Year == 2011) %>% group_by(State, incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      gvisGeoChart(locationvar = "State", colorvar = "Count", 
                   options = list(region="US", displayMode="regions", 
                                  resolution="provinces", width="auto", height="auto", 
                                  backgroundColor = "#dbe7ff", colors="['#e0d7da', '#c84b4b']"))
      # left_join(., polygon_df, by = c("State")) %>% st_sf() %>% 
      # tm_shape() + tm_fill("Count", palette = "Reds", contrast = c(0.2, 0.9), title = "Emergency Totals") + tm_borders() + tm_shape(country_shape) + tm_borders()
  )
  
  output$pie_2011 <- renderGvis(
    data %>% filter(Year == 2011) %>% group_by(incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      gvisPieChart(labelvar = "incidentType", numvar = "Count", 
                   options=list(width="400px", height="350px",
                                title = "Proportions of Emergencies, 2011",
                                chartArea= "{left:40, top:30, bottom:0, right:0}", 
                                colors="['#ffc2cd', '#c69c6e', '#ce412a', '#001489', '#008080', '#dbe7ff', '#00ffff']"))
  )
  
  output$map_2020 <- renderGvis(
    data %>% filter(Year == 2020) %>% group_by(State, incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      gvisGeoChart(locationvar = "State", colorvar = "Count", 
                   options = list(region="US", displayMode="regions", 
                                  resolution="provinces", width="auto", height="auto", 
                                  backgroundColor = "#dbe7ff", colors="['#e0d7da', '#c84b4b']"))
      # left_join(., polygon_df, by = c("State")) %>% st_sf() %>% 
      # tm_shape() + tm_fill("Count", palette = "Reds", contrast = c(0.2, 0.9), title = "Emergency Totals") + 
      # tm_borders() + tm_shape(country_shape) + tm_borders()
  )
  
  output$pie_2020 <- renderGvis(
    data %>% filter(Year == 2020) %>% group_by(incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      gvisPieChart(labelvar = "incidentType", numvar = "Count", 
                   options=list(width="400px", height="350px",
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
  
  output$totals_table <- DT::renderDataTable(
    datatable(state_count) %>% 
      formatStyle("Count", background = styleColorBar(state_count$Count, '#c84b4b'), 
                  backgroundSize = '100% 90%', backgroundRepeat = 'no-repeat', backgroundPosition = 'center')
  )
  
  output$five_states <- renderPlot(
    data %>% filter(State == "Texas"|State == "Florida"|State == "California"|State == "Washington"|State == "Oklahoma") %>% 
      filter(incidentType == "Fire" | incidentType == "Hurricane" | incidentType == "Flood" | 
               incidentType == "Severe Storm(s)" | incidentType == "Tornado" | incidentType == "Earthquake" |  
               incidentType == "Severe Ice Storm" | incidentType == "Biological") %>% 
      group_by(State, incidentType) %>% summarise(Count = length(unique(femaDeclarationString))) %>% 
      ggplot(aes(x=reorder(incidentType, Count, max), y=Count)) + geom_col(aes(fill = State)) + 
      labs(title="Emergency Distribution, 1953-2020", x = "Emergency Type") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + theme(legend.position = "none") +
      scale_fill_manual(values = c("#f29591", "#486bea", "#e5d2d1", "#d6a23b", "#152596")) + ylim(c(0, 300)) +
      geom_text(aes(label = Count),  hjust = 0.4, vjust = -0.5) + facet_grid(State ~ .)
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
                                backgroundColor = "#dbe7ff", colors="['#e0d7da', '#c84b4b']"))
  )
  
  output$disasters_table <- DT::renderDataTable(
    datatable(data_tb) %>% formatStyle("Total", background = styleColorBar(data_tb$Total, '#b82b4b'),
                  backgroundSize = '100% 90%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center')
  )
  
  output$delay_graph <- renderPlot(
    data %>% mutate("Delay" = declarationDate - incidentBeginDate) %>% 
      # data has incorrect inputs (disaster start date happens after the disaster declaration date, because FEMA is psychic)
      filter(Delay >= 0, Delay != 2671) %>% group_by(Year) %>% 
      summarise(Count = length(unique(femaDeclarationString)), Avg_Delay = as.numeric(gsub(" days", "", mean(Delay)))) %>% 
      ggplot(aes(x=Year, y=Avg_Delay)) + geom_line(arrow = arrow(angle = 30, ends = "last", type = "closed", length = unit(0.15, "inches"))) + ylab("Average Delay (days)") +
      geom_vline(xintercept = c(1961, 1969, 1974, 1977, 1981, 1989, 1993, 2001, 2009, 2017), colour='grey') +
      annotate("text", x = c(1957, 1965, 1971.5, 1975.5, 1979, 1985, 1991, 1997, 2005, 2013, 2019 ), y = 66, label = c("Eisenhower", "Kennedy/\nJohnson", "Nixon", "Ford", "Carter", "Reagon", "Bush Sr.", "Clinton", "Bush Jr.", "Obama", "Trump"), size=3) +
      annotate("rect", xmin = 1953, xmax = 1961, ymin = 0, ymax = 65, alpha = .2, fill='darkred') +
      annotate("rect", xmin = 1961, xmax = 1969, ymin = 0, ymax = 65, alpha = .2, fill='darkblue') +
      annotate("rect", xmin = 1969, xmax = 1974, ymin = 0, ymax = 65, alpha = .2, fill='darkred') +
      annotate("rect", xmin = 1974, xmax = 1977, ymin = 0, ymax = 65, alpha = .2, fill='darkred') +
      annotate("rect", xmin = 1977, xmax = 1981, ymin = 0, ymax = 65, alpha = .2, fill='darkblue') +
      annotate("rect", xmin = 1981, xmax = 1989, ymin = 0, ymax = 65, alpha = .2, fill='darkred') +
      annotate("rect", xmin = 1989, xmax = 1993, ymin = 0, ymax = 65, alpha = .2, fill='darkred') +
      annotate("rect", xmin = 1993, xmax = 2001, ymin = 0, ymax = 65, alpha = .2, fill='darkblue') +
      annotate("rect", xmin = 2001, xmax = 2009, ymin = 0, ymax = 65, alpha = .2, fill='darkred') +
      annotate("rect", xmin = 2009, xmax = 2017, ymin = 0, ymax = 65, alpha = .2, fill='darkblue') +
      annotate("rect", xmin = 2017, xmax = 2020, ymin = 0, ymax = 65, alpha = .2, fill='darkred')
  )
  
  output$longest_disaster <- DT::renderDataTable(
    table_longest %>% datatable(options = list(dom = 't', autoWidth = TRUE)) %>% 
      formatStyle("Duration (days)", background = styleColorBar(table_longest$`Duration (days)`, '#b82b4b'))
      )
  
  output$corr_plot <- renderPlot(
    data %>% filter(incidentType == "Fire" | incidentType == "Hurricane" | incidentType == "Flood" | 
                    incidentType == "Severe Storm(s)" | incidentType == "Tornado" | incidentType == "Snow" |  
                    incidentType == "Severe Ice Storm" | incidentType == "Drought" | incidentType == "Freezing") %>% 
      group_by(incidentType, Year) %>% 
      summarise(Count = length(unique(femaDeclarationString))) %>% 
      pivot_wider(names_from = incidentType, values_from = Count, values_fill = list(Count = 0)) %>% cor() %>% 
      ggcorrplot(outline.col = "white", insig = "blank")
  )
  
  output$year_gif <- renderImage(
    list(src = "year_anim.gif",
         contentType = 'image/gif', 
         width = 400,
         height = 300),
         # alt = "This is alternate text"
    deleteFile = FALSE     
    )
  
}
