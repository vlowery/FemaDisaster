
shinyUI(
  dashboardPage(skin = "red", 
    dashboardHeader(title="Disasters"),
    dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("Introduction", tabName = "intro", icon = icon("info")),
        menuItem("Disaster Types", tabName = "disaster_types", icon = icon("car-crash")),
        menuItem("Totals by Year", tabName = "years", icon = icon("calendar"), 
                 menuSubItem("Overview", tabName = "overview_years"),
                 menuSubItem("2005 Investigation", tabName = "2005"),
                 menuSubItem("2020 Investigation", tabName = "2020")),
        menuItem("Totals by State", tabName = "states", icon = icon("globe")),
        menuItem("Delays to be Recognized", tabName = "when", icon = icon("map")),
        menuItem("Assistance", tabName = "assistance", icon = icon("heartbeat")),
        HTML('<li> <a href="#shiny-tab-worst" data-toggle="tab" data-value="worst">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span> The Worst</span>
                        </a> </li>'),
        menuItem("Conclusions", tabName = "conclusions")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "intro",
                fluidRow(column(width = 6, offset = 3, align = "center", box(width = 12, h1(tags$b("U.S. National Emergency Declarations:\n")),
                                                           h2(tags$b("Where FEMA Acts the Most, and Why")),
                                                           br(),
                                                           img(src = "hurricane.jpg", width = 500),
                                                           h5("'Hurrican Devastation Charley, from WikiImages'"),
                                                           br(),
                                                           br(),
                                                           h4(p("Created on April 1, 1979 by President Jimmy Carter, the Federal Emergency Management Agency's 
                                                              (FEMA) mission was clear, and their mission statement just as short: 'Helping people before, during, 
                                                              and after disasters'. While officially organized 41 years ago, their records date back to emergencies 
                                                              declared as early as January 1, 1953."), p("This project will disect the organization's allocation of 
                                                              emergency resources, aiming to find patterns in disasters. If a pattern can be detected, and thus a 
                                                              disaster can be predicted, funds could be reallocated and possibly saved by proactively safe-guarding 
                                                              the possible disaster zone. ")),
                                                           br(),
                                                           h5("Research and modelling by Victoria Lowery."))))
                ),
        tabItem(tabName = "disaster_types",
                h2("Most Common Emergencies"),
                fluidRow(box("In the past 68 years, the most common emergency declared has been due to fires. Surprisingly, second and third place are due to 
                             severe storms and flooding. Hurricanes, in fourth place, drop by more than half of its predecessor. While hurricanes maybe hold the attention
                             of news channels and papers longer, they occur far less frequently than the average bad storm. Additionally, hurricanes come with a considerable 
                             amount of notice, unlike flash floods. Interestingly, a new category established this year, the 'biological disaster', is already ranked seventh 
                             place in total emergency declarations due to COVID-19."),
                         box(dataTableOutput("disasters_table"))
                ),
                h2("What Constitutes an Emergency"),
                fluidRow(
                  box(width=3, title="A History of the U.S. Emergency", solidHeader = TRUE, status = "primary", 
                      "This is a history of the US's emergency response, with FEMA and etc. MAYBE MAKE THIS A TAB WITH EXTRA INFO, BUT MAKE THE FIRST TAB DISASTER EXPLANATIONS"),
                  box(width = 3, radioButtons("radio1", label = h3("Select Disaster Type:"),
                                                     choices = sort(unique(data$incidentType)), 
                                                     selected = "Hurricane")),
                  box(width = 6, plotOutput("disaster_chart"))),
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
                    box(title = "REFRAMING BY TOTAL COUNTIES AFFECTED", collapsible = TRUE, collapsed = TRUE, status = "danger", solidHeader = TRUE, plotOutput("reframe")),
                    box("If we reframe our look by counting total individual counties affected by disasters rather than 
                    unique FEMA disaster IDs that can cover from one to hundreds of counties under one emergency ID, we see two distinct years stand out. 
                        As this is an approximation for total citizens affected, it makes sense that the two stand out years are 2005, the year of Hurricane 
                        Katrina, and 2020, as COVID-19 spreads far and wide throughout the country."))
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
                  h2("What's Happening in States with Higher Counts?"),
                  fluidRow(
                    box(plotOutput(height = 700, "five_states")),
                    box("Texas' large number of emergencies seems to be mostly due to its high number of fires and hurricanes. 
                        When one thinks of a place to be hit hard by hurricanes, Texas might not have been the first to come to mind. 
                        To see how Texas compares to Florida, a state that is usually the first to feel the wrath of any hurricane hitting the U.S., 
                        I've plotted Florida's distribution of state emergencies.")),
                  # fluidRow(
                  #     box(plotOutput("florida")))
                )),
        tabItem(tabName = "when", 
                h2("How Has Disaster Recognition Progressed?"),
                box("Every disaster has an associated start date in addition to a disaster declaration date. This tab will look into how the difference 
                    in time has shortened or lengthened. Are certain presidents quick about declaring emergencies, or are some presidents slow with the aid.")
                ),
        tabItem(tabName = "assistance", 
                h2("The Distribution of Aid"),
                box("Aid to civilians can be requested if certain requirements are met. This page will explore whether aid has been equally doled out for similar 
                    disasters in different states and counties. This will also begin the exploration of cost allocation, as aid to civilians requires the federal 
                    governemnt to use tax payer's money to save citizens in need. Ideally assistance is delivered when the emergency was unavoidable. This page 
                    will discover whether certain states have become 'repeat offenders' and are using tax money for emergencies they could avoid.")
                ),
        tabItem(tabName = "worst", 
                h2("The Longest-Lasting Emergency"),
                br(),
                h2("The Most Wide-Spread Disaster"),
                ),
        tabItem(tabName = "conclusions", 
                h2("Given The Findings:")
                )
      )
    )
  )
)
