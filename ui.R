
shinyUI(
  dashboardPage(
    dashboardHeader(title="Let's Talk About Disasters"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Introductions", tabName = "intro", icon = icon("info"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "intro", 
                fluidPage(
                  fluidRow("THIS IS THE BEGINNING.")
                  
                ))
      )
    )
  )
)
