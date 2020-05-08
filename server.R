

function(input, output, session){
  
  output$totals_yearly <- renderPlot(
    data %>% group_by(Year) %>% summarise(Count = n()) %>% ggplot(aes(x=Year, y=Count)) + 
      geom_col(aes(fill=ifelse(Year == 2005|Year==2020, "#008080", "#ce412a"))) + 
      ylab("Emergency Count") + ggtitle("Total Emergency Count by Year") + theme(legend.position = "none") + 
      geom_text(aes(label = ifelse(Year == 2005|Year==2020, Count, "")),  vjust = -0.5) +
      scale_x_continuous(breaks=seq(1950, max(data$Year), 5))
    ## ADD A BOX WITH DARKER COLORING, THEN ADD COLORING TO ZOOM GRAPH
  )
  
  output$zoom_in <- renderPlot(
    data %>% group_by(Year) %>% summarise(Count = n()) %>% ggplot(aes(x=Year, y=Count)) + 
      geom_col(aes(fill=ifelse(Year == 2005|Year==2020, "#008080", "#ce412a"))) + 
      ylab("Emergency Count") + ggtitle("Total Emergency Count, Zoomed in to <2,500 Cases") + theme(legend.position = "none") + 
      coord_cartesian(ylim=c(0,2500)) + scale_x_continuous(breaks=seq(1950, max(data$Year), 5))
    ## ADD A BOX WITH ZOOM COLORING FROM YEARLY GRAPH
  )
  
  output$pie_2005 <- renderGvis(
    data %>% filter(Year == 2005) %>% group_by(incidentType) %>% summarise(Count = n()) %>% 
      gvisPieChart(labelvar = "incidentType", numvar = "Count", 
                   options=list(width="450px", height="450px", 
                                title = "Proportions of Emergencies, 2005",
                                chartArea= "{left:20, top:30, bottom:0, right:0}", 
                                slices="[{}, {offset: .2}, {offset: .3}, {}, {}, {offset: .2}, {}]", 
                                colors="['#ffc2cd', '#ce412a', '#c69c6e', '#001489', '#008080', '#00ffff', '#effd5f']"))
  )
  
  output$pie_2020 <- renderGvis(
    data %>% filter(Year == 2020) %>% group_by(incidentType) %>% summarise(Count = n()) %>% 
      gvisPieChart(labelvar = "incidentType", numvar = "Count", 
                   options=list(width="450px", height="450px", 
                                title = "Proportions of Emergencies, 2020",
                                chartArea= "{left:20, top:30, bottom:0, right:0}", 
                                slices="[{}, {offset: .3}, {offset: .2}, {offset: .4}, {offset: .4}, {offset: .4}, {offset: .4}]", 
                                colors="['#808000', '#ce412a', '#c69c6e', '#001489', '#008080', '#00ffff', '#effd5f']"))
  )
  
  output$totals_map <- renderGvis(
    #FILTER FOR UNIQUE EMERGENCIES, NOT COUNTY COUNTS
    gvisGeoChart(state_count, 
                 locationvar = "State", 
                 colorvar = "Total Emergencies",
                 options=list(region="US", displayMode="regions", resolution="provinces", width="auto", height="auto",
                              colors="['#e0d7da', '#c84b4b']"))
  )
  
  output$totals_table <- renderDataTable(
    datatable(state_count) %>% 
      formatStyle("Total Emergencies", background = styleColorBar(state_count$`Total Emergencies`, '#c84b4b'), 
                  backgroundSize = '100% 90%', backgroundRepeat = 'no-repeat', backgroundPosition = 'center')
  )
  
  output$texas <- renderPlot(
    data %>% filter(State == "Texas") %>% group_by(incidentType) %>% summarise(Count = n()) %>% 
      ggplot(aes(x=reorder(incidentType, Count, max), y=Count)) + geom_col(fill="#d6a23b") + 
      labs(title="Texas' Emergency Distribution, 1953-2020", x = "Emergency Type") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      geom_text(aes(label = ifelse(incidentType == "Hurricane"|incidentType == "Fire", Count, "")),  vjust = -0.5)
  )
  
  output$florida <- renderPlot(
    data %>% filter(State == "Florida") %>% group_by(incidentType) %>% summarise(Count = n()) %>% 
      ggplot(aes(x=reorder(incidentType, Count, max), y=Count)) + geom_col(fill="#718cfe") + 
      coord_cartesian(ylim=c(0,1250)) + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title="Florida's Emergency Distribution, 1953-2020", x = "Emergency Type") +
      geom_text(aes(label = ifelse(incidentType == "Hurricane", Count, "")),  vjust = -0.5)
  )
  output$disaster_chart <- renderPlot(
    data %>% filter(data$incidentType == input$radio1) %>% group_by(Year) %>% 
      summarise(Count = n()) %>% ggplot(aes(x=Year, y=Count)) + geom_col(fill = "#2f3337") + 
      scale_x_continuous(breaks=seq(1950, max(data$Year), 2)) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  )
  
  output$disasters_table <- renderDataTable(
    datatable(data1) %>% formatStyle("Total", background = styleColorBar(data1$Total, '#b82b4b'),
                  backgroundSize = '100% 90%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center')
  )
  
  
  
}
