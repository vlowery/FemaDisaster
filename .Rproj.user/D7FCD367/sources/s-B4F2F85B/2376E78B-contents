
shinyUI(
  dashboardPage(
    dashboardHeader(title="Disasters"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Introductions", tabName = "intro", icon = icon("info")),
        menuItem("Overall Figures", tabName = "overall", icon = icon("chart-bar")),
        menuItem("Disaster Types", tabName = "disaster_types", icon = icon("car-crash"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "intro"),
        tabItem(tabName = "overall", 
                fluidPage(
                  fluidRow(
                    box("THIS IS THE BEGINNING."),
                    box(htmlOutput("totals_map"))
                  ),
                  fluidRow(dataTableOutput("totals_table"))
                  
                )),
        tabItem(tabName = "disaster_types",
                fluidRow(box(width = 3, radioButtons("radio1", label = h3("Select Disaster Type:"),
                             choices = sort(unique(data$Disaster.Type)), 
                             selected = "Hurricane")),
                box(width = 9, plotOutput("disaster_chart"))),
                fluidRow(dataTableOutput("disasters_table"))
                )
      )
    )
  )
)
