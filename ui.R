
shinyUI(
  dashboardPage(skin = "red", 
    dashboardHeader(title="Disasters"),
    dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("Introductions", tabName = "intro", icon = icon("info")),
        menuItem("Disaster Types", tabName = "disaster_types", icon = icon("car-crash")),
        menuItem("Totals by Year", tabName = "years", icon = icon("calendar"), 
                 menuSubItem("Overview", tabName = "overview_years"),
                 menuSubItem("2005 Investigation", tabName = "2005"),
                 menuSubItem("2020 Investigation", tabName = "2020")),
        menuItem("Totals by State", tabName = "states", icon = icon("globe")),
        menuItem("Where Are They Happening", tabName = "where", icon = icon("map"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "intro",
                fluidRow(box()),
                fluidRow(),
                fluidRow(box(width = 4, offset = 4, "National Emergency Declarations: How Many and How Much They Cost"))
                ),
        tabItem(tabName = "disaster_types",
                h2("What Constitutes an Emergency"),
                fluidRow(
                  box(width=3, title="A History of the U.S. Emergency", solidHeader = TRUE, status = "primary", 
                      "This is a history of the US's emergency response, with FEMA and etc. MAYBE MAKE THIS A TAB WITH EXTRA INFO, BUT MAKE THE FIRST TAB DISASTER EXPLANATIONS"),
                  box(width = 3, radioButtons("radio1", label = h3("Select Disaster Type:"),
                                                     choices = sort(unique(data$incidentType)), 
                                                     selected = "Hurricane")),
                  box(width = 6, plotOutput("disaster_chart"))),
                h2("Most Common Emergencies"),
                fluidRow(box("We see most emergencies declared were for dangerous rainy weather: storms, floods and hurricanes."),
                         box(dataTableOutput("disasters_table"))
                )
        ),
        tabItem(tabName = "overview_years", 
                fluidPage(
                  h2("Total Emergencies by Year"),
                  fluidRow(
                    box(plotOutput("totals_yearly")),
                    box("This model to the left displays emergency declaration totals from the years 1953 to May 2020. 
                    There is a general increase in emergencies declared, however, two years in particular 
                    saw an incredible rise in emergencies. A total of 4,653 emergencies were declared in 2005, and within 
                    the first five months of 2020, over 7,700 emergencies have been declared. Excluding these two years, 
                    the mean emergency count is ", round(mean_yearly_emrg), " per year.")),
                  fluidRow(
                    box(title = "ZOOM IN", collapsible = TRUE, collapsed = TRUE, status = "danger", solidHeader = TRUE, plotOutput("zoom_in")),
                    box("If we take a closer look and zoom in without regards to 2005 and 2020, the next highest year 
                        tops out at roughly 2,500- which is almost half of 2005's total. We can see just how extreme 2005 
                        and 2020 are in comparison to the rest of the years. "))
                  )),
        tabItem(tabName = "2005", "Here I will discuss 2005.",
                box(htmlOutput("pie_2005"))
                ),
        tabItem(tabName = "2020", "Here I discuss 2020.",
                box(width = 5, htmlOutput("pie_2020"))
                ),
        tabItem(tabName = "states",
                fluidPage(
                  fluidRow(h2("Total Emergencies by State")),
                  fluidRow(
                    box(width= 3, "This section serves to show where emergencies are happening. The table 
                    belows shows Texas has far more emergencies than any other state. Texas has more 
                    emergencies than New York and California combined. Why is that?"),
                    box(width = 5, htmlOutput("totals_map")),
                  box(width=4, dataTableOutput("totals_table"))),
                  h2("What's Happening in Texas"),
                  fluidRow(
                    box(plotOutput("texas")),
                    box("Texas' large number of emergencies seems to be mostly due to its high number of fires and hurricanes. 
                        When one thinks of a place to be hit hard by hurricanes, Texas might not have been the first to come to mind. 
                        To see how Texas compares to Florida, a state that is usually the first to feel the wrath of any hurricane hitting the U.S., 
                        I've plotted Florida's distribution of state emergencies.")),
                  fluidRow(
                      box(plotOutput("florida")))
                )),
        tabItem(tabName = "where", 
                h2("Where Are Most of These Emergencies Happening?"),
                box("We saw that most emergencies have been declared in Texas, but "))
      )
    )
  )
)
