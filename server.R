

function(input, output, session){
  
  
  output$totals_map <- renderGvis(
    gvisGeoChart(state_count, 
                 locationvar = "State", 
                 colorvar = "Total Emergencies",
                 options=list(region="US", displayMode="regions", resolution="provinces", width="auto", height="auto",
                              colors="['#e0d7da', '#c84b4b']"))
  )
  
  output$totals_table <- renderDataTable(
    datatable(state_count) %>% formatStyle("Total Emergencies", background = styleColorBar(state_count$`Total Emergencies`, '#b82b4b'), 
                                           backgroundSize = '100% 90%', backgroundRepeat = 'no-repeat', backgroundPosition = 'center')
  )
  
  output$disaster_chart <- renderPlot(
    data %>% filter(data$Disaster.Type == input$radio1) %>% group_by(Year) %>% 
      tally() %>% ggplot(aes(x=Year, y=n)) + geom_col(fill = "red") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  )
  
  output$disasters_table <- renderDataTable(
    datatable(data1) %>% formatStyle("Total", background = styleColorBar(data1$Total, '#b82b4b'),
                  backgroundSize = '100% 90%',
                  backgroundRepeat = 'no-repeat',
                  backgroundPosition = 'center')
  )
  
  
  
}
