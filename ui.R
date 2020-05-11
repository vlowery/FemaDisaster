
shinyUI(
  dashboardPage(skin = "red", 
    dashboardHeader(title="Disasters"),
    dashboardSidebar(
      sidebarMenu(
        id = "tabs",
        menuItem("Introduction", tabName = "intro", icon = icon("info")),
        menuItem("Disaster Types", tabName = "disaster_types", icon = icon("car-crash")),
        menuItem("Totals by Year", tabName = "overview_years", icon = icon("calendar")), 
        menuItem("Totals by State", tabName = "states", icon = icon("globe")),
        menuItem("Delays to be Recognized", tabName = "when", icon = icon("map")),
        # menuItem("Assistance", tabName = "assistance", icon = icon("heartbeat")),
        # HTML('<li> <a href="#shiny-tab-worst" data-toggle="tab" data-value="worst">
        #                 <i class="fas fa-exclamation-triangle"></i>
        #                 <span> The Worst</span>
        #                 </a> </li>'),
        menuItem("Conclusions", tabName = "conclusions")
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "intro",
                fluidRow(column(width = 6, offset = 3, align = "center", box(width = 12, h1(tags$b("U.S. National Emergency Declarations:\n")),
                                                           h2(tags$b("Where FEMA Acts the Most, and Why")),
                                                           br(),
                                                           img(src = "hurricane.jpg", style="width: 100%"),
                                                           h5("'Hurrican Devastation Charley', from WikiImages"),
                                                           br(),
                                                           br(),
                                                           h4(p("Created on April 1, 1979 by President Jimmy Carter, the Federal Emergency Management Agency's 
                                                              (FEMA) mission was clear, and their mission statement just as short: 'Helping people before, during, 
                                                              and after disasters'. While officially organized 41 years ago, their records date back to emergencies 
                                                              declared as early as January 1, 1953."), p("This project will disect the organization's allocation of 
                                                              emergency resources for the more than 4,000 registered emergencies, aiming to find patterns in disasters. If a pattern can be detected, and thus a 
                                                              disaster can be predicted, funds could be reallocated and possibly saved by proactively safe-guarding 
                                                              the possible disaster zones. ")),
                                                           br(),
                                                           h5("Research and modelling by Victoria Lowery."))))
                ),
        tabItem(tabName = "disaster_types",
                h2("Most Common Emergencies"),
                fluidRow(box(width = 4, "In the past 68 years, the most common emergency declared has been due to fires. Surprisingly, second and third place are due to 
                             severe storms and flooding. Hurricanes, in fourth place, drop by more than half of its predecessor. While hurricanes maybe hold the attention
                             of news channels and papers longer, they occur far less frequently than the average bad storm. Additionally, hurricanes come with a considerable 
                             amount of notice, unlike flash floods. Interestingly, a new category established this year, the 'biological disaster', is already ranked seventh 
                             place in total emergency declarations due to COVID-19."),
                         box(width = 4, title = "Declaration Tallies for Emergency Categories", DT::dataTableOutput("disasters_table"))
                ),
                h2("What Constitutes an Emergency"),
                fluidRow(
                  column(width = 3, 
                  box(width=12, title="At a Glance", solidHeader = TRUE, status = "warning", 
                      p(tags$b("Biological:"), ("first case in 2020")),
                      p(tags$b("Chemical:"), "only case in 2014, West Virginia"),
                      p(tags$b("Fire:"), "cases increasing since 1996"),
                      p(tags$b("Human Cause:"), " Oklahoma experienced two explosions at the Federal Court House, one week apart"),
                      p(tags$b("Other:"), "Alaska experienced severe hardship three winters in a row from '53 - '55; 
                        Texas and Louisiana experienced the loss of Space Shuttle Columbia; 
                        New York and New Jersey suffered a break-out of the West Nile Virus: multiple counties in Ohio suffered a severe power outage for three days"),
                      p(tags$b("Terrorist:"), "September 11th, 2001 was actually coded as a 'Fire' emergency in New York, so the only recorded terrorist emergencies 
                        are first, the additional plane on 9/11 that struck the Pentagon in Virginia and second, the Boston Marathon bombings in 2013"),
                      p(tags$b("Tsunami, Typhoon, Volcano:"), "declared predominantly by Hawaii, one of the U.S.'s most coastal and exposed state")),
                  # box(width = 12, title = "A History of the U.S. Emergency", solidHeader = TRUE, status = "warning",
                  #     p("This will elaborate on the history of declaring an emergency."))
                  ),
                  box(width = 3, radioButtons("radio1", label = h3("Select Disaster Type:"),
                                                     choices = sort(unique(data$incidentType)), 
                                                     selected = "Hurricane")),
                  box(title = textOutput("text1"), solidHeader = TRUE, status = "warning", column(width = 12, tags$b("Distribution by Year for Selected Emergency"),
                                                                                                  plotOutput("disaster_chart"), br(), tags$b("The United States: Distribution of 
                                                                                                                                             Selected Emergency, 1953 - 2020"), 
                                                                                                  htmlOutput(width = "auto", "disaster_map")))),
        ),
        tabItem(tabName = "overview_years", 
                fluidPage(
                  h2("Total Emergencies by Year"),
                  fluidRow(
                    box(width = 5, plotOutput("totals_yearly")),
                    box(width = 4, "FEMA assigns a unique ID number to each emergency declared. This model to the left shows the tally of every emergency declaration from the year 1953 to May 2020. 
                    There is a general increase in emergencies declared, however, three years in particular 
                    saw an incredible rise in emergencies. A total of 159 emergencies were declared in 1996, a considerable jump from all years prior. 2011 also saw a jump in case numbers, 
                    in fact more than double the previous year's count. And within the first five months of 2020, over 154 emergencies have been declared, mostly because of complications from COVID-19. 
                    Excluding these three years, the mean emergency count is ", round(mean_yearly_emrg), " per year.")),
                  fluidRow(
                    box(width = 5, title = "REFRAMING BY TOTAL COUNTIES AFFECTED", collapsible = TRUE, collapsed = TRUE, status = "danger", solidHeader = TRUE, 
                        plotOutput("reframe"), p(tags$b("Hurricane Katrina and COVID-19 drastically increase 2005 and 2020 respectively."))),
                    box(width = 4, "If we reframe our look to counting total individual counties affected by disasters rather than 
                    unique FEMA disaster IDs, which can cover one to hundreds of counties under one ID, we see two distinct years stand out. 
                        As this is an approximation for total citizens affected, it makes sense that the two stand out years are 2005, the year of Hurricane 
                        Katrina, and 2020, as COVID-19 spreads far and wide throughout the country.", br(), "Additional analysis exploring population count rather than FEMA ID counts 
                        will be added to further identify the weight of each emergency by citizens compromised. This optimistically will balance the fact that Texas, a very large 
                        state but with a smaller population density than say parts of New York or Florida, will possibly be more likely to expereince emergencies, however the 
                        effects of certain disasters may affect far fewer than if the same disaster were to occur in another state.", br(), br(), "It's important to keep in mind that this visual is an approxiamte. 
                        Emergencies labeled 'Statewide' have been weighted by their count of counties. In other cases, emergency documentation lists specific counties affected, and for those cases the explicit county count has been used.")),
                  h2("What's Happening in 1996, 2011, and 2020"),
                  fluidRow(
                    box(width = 2, title = "1996", "For Texas, 1996 was a year of one fire after another. First in February, a particularly large grass fire burned out of control, 
                        devastating not acres but miles of farms, homes, and land. Another particularly bad fire, Texas' Little Cypress Fire, was contained by April, 
                        however many other fires continued to ignite. The state continued to burn into the hottest months of summer leading the President, George Bush, to declare a federal disaster in the state."),
                    box(width = 5, htmlOutput("pie_1996")),
                    box(width = 5, title = "Distribution of Emergencies Declared, 1996", solidHeader = TRUE, status = "danger", plotOutput("map_1996"))),
                  fluidRow(
                    box(width = 2, title = "2011", "2011 broke many records, including the most destructive fire in Texas' history, the Bastrop County Complex fire. 
                        In total, Texas comprised 47% of all acreage burned in the United States in 2011[1].", 
                        br(), br(), h6("[1] Tripp, Leslie; Gallman, Stephanie (April 19, 2011). 'Arrest made in connection with Texas wildfire near Austin'. CNN.com. Retrieved 2011-04-18.")),
                    box(width = 5, htmlOutput("pie_2011")),
                    box(width = 5, title = "Distribution of Emergencies Declared, 2011", solidHeader = TRUE, status = "danger", plotOutput("map_2011"))),
                  fluidRow(
                    box(width = 2, title = "2020", "COVID-19 has overtaken nearly all of 2020's registered emergencies."),
                    box(width = 5, htmlOutput("pie_2020")),
                    box(width = 5, title = "Distribution of Emergencies Declared, 2020", solidHeader = TRUE, status = "danger", plotOutput("map_2020")))
                  )),
        tabItem(tabName = "states",
                fluidPage(
                  fluidRow(h2("Total Emergencies by State")),
                  fluidRow(
                    column(width = 3, box(width = 12, "According to the table on the far right, Texas takes the lead with the most emergencies recorded since 1953 with a total of 358 emergency declarations.
                        Trailing only a few counts behind is California with 323 total emergencies.", br(), br(), "The next two states, Oklahoma and Washington, might come as a surprise in the 
                        list before the hurricane-prone state of Florida. To dive deeper in what specifically is happening in these top five states, the section below disects top disaster categories for each state."),
                          infoBox(width = 12, fill = TRUE, color = "yellow", title = "Largest State (area)", subtitle = "17.5%", value = "Alaska"),
                          infoBox(width = 12, fill = TRUE, color = "yellow", title = "Second Largest", subtitle = "7%", value = "Texas"),
                          infoBox(width = 12, fill = TRUE, color = "yellow", title = "Third Largest", subtitle = "4%", value = "California")),
                    box(title = "Total Emergencies by State, 1953 - 2020", width = 5, htmlOutput(width = "auto", "totals_map")),
                    box(width=4, DT::dataTableOutput("totals_table"))),
                  h2("What's Happening in States with Higher Counts?"),
                  fluidRow(
                    box(plotOutput(height = 700, "five_states")),
                    box("With the knowledge that Texas experienced two devastating years of widespread grass fires, it is rational to expect Texas' distribution of emergencies to pool in the 'Fire' category.  
                        Additionally, California is known for struggling with hot weather, dry seasons, and high winds: the perfect recipe for forest fires. While Texas had a few boughts of extreme fire disaster, 
                        California continually experiences low numbers of fires, collecting up over the years. Texas neighbor Oklahoma also struggles with a high fire emergency count, but surprisingly Washington 
                        has a dry season, too, that often instigates forest fires. Washington as of 2019 has proposed a 'groundbreaking strategic plan' to buid up the state's fire prevention team, 
                        in addition to strengthening its current firefighter and response teams.[2]", br(), br(), h6("[2] Joseph O'Sullivan (January 17, 2019). 'Washington state wants to add firefighters and 
                                                                                                                     training academy to beef up wildfire response'. The Seattle Times."))),
                )),
        tabItem(tabName = "when", 
                h2("How Has Disaster Recognition Progressed?"),
                column(width = 6, box(width = 12, "Every disaster has an associated start date in addition to a disaster declaration date. The graph to the right looks into how the difference 
                    in time has actually lengthened, delaying the release of federal aid and funds for safe-guarding citizens 
                    in disaster zones. Further research would compare certain presidents' and their speed at declaring emergencies during their term.", 
                    br(), br(), p("Missing from the graph on the right is one outlying data point, an emergency declared in Hawaii 
                    for the eruption of its volcano Kīlauea. This volcano began activity in 1983, but as much of the land surrounding the highly-active 
                    volcano was already fairly void of human presence, it was only later as the volcano continued to errupt that an emergency was 
                    declared in 1990 to evacuate citizens in the path of actively flowing lava. This delay in need for an emergency 
                    is misleading and therefore excluded from the dataset for this graph.")),
                    box(width = 12, background = "yellow", solidHeader = TRUE, status = "warning", title = tags$b("HOW FEMA IS IMPROVING"), "After Hurricane Sandy in 2012, President Obama signed the Sandy Recovery Improvement Act of 2013, declaring that 
                        federally recognized tribal governments have the option to request aid directly from the President. Previously, tribes experiencing hardship had to petition the 
                        Governor of the state to formally request the President to declare an emergency. And sometimes it wasn't only one Governor requesting or denying tribes aid. For every state the tribe's 
                        land falls under, a formal petition was required for each state's Governor.")),
                box(title = "Average Delay from Incident Start to Emergency Declaration, by President", solidHeader = TRUE, status = "primary", plotOutput("delay_graph")),
                h2("The Longest-Lasting Emergency"),
                br(),
                fluidRow(column(width = 12, box(width = 12, DT::dataTableOutput(width = "100%", "longest_disaster"))))
                
                ),
        # tabItem(tabName = "assistance", 
        #         h2("The Distribution of Aid"),
        #         box("Aid to civilians can be requested if certain requirements are met. This page will explore whether aid has been equally doled out for similar 
        #             disasters in different states and counties. This will also begin the exploration of cost allocation, as aid to civilians requires the federal 
        #             governemnt to use tax payer's money to save citizens in need. Ideally assistance is delivered when the emergency was unavoidable. This page 
        #             will discover whether certain states have become 'repeat offenders' and are using tax money for emergencies they could avoid.")
        #         ),
        # tabItem(tabName = "worst", 
        #         h2("The Most Wide-Spread Disaster"),
        #         ),
        tabItem(tabName = "conclusions", 
                h2("What This Tells Us:"),
                fluidRow(
                  column(width = 4, box(width = 12, "From both looking at the distribution through the years as well as across the states, the data suggests that fire 
                      emergencies are a major category. Fire emergencies have been increasing since the start of FEMA's documentation, 
                      and many states are susceptible experiencing emergencies due to fires.", br(), br(), "Because there are so many different disaster categories and some are misleadingly labeled, for example September 11, 
                      2001 is categorized not as a terrorist incident but as an incident of fire, unlike Virginia who filed the attack on 
                      the Pentagon on the same day as an incident of terrorism, a correlation plot can be difficult. FEMA depends on each individual governor's 
                      office to describe and categorie disasters, leading to incongruencies in the data. In addition, there are so few repeatable and predicatble emergency 
                      categories. Chemical spills have only been documented once, and biological emergencies have only been documented for 2020. 
                      Earthquakes are sparse in this data set, and tsunamis even rarer.", br(), br(), "The next step for this project is to look at smaller instances, 
                      ot only the trajesties but every weaker variation of an emergency category. This could include smaller quakes and smaller storms; even though they may 
                      pass through causing little to no damage, having these intermidiary points paints a more defined picture than only looking at large disasters.")),
                 column(width = 8, 
                        box(width = 7, height = 375, offset = 3, title = "Growth of Disaster Count per State, 1953 - 2020", imageOutput("year_gif")),
                        box(title = "Correlation between Emergency Categories", 
                            footer = tags$i("Emergency categories have been limited to those with more than 30 instances and which occur across greater than one year."), 
                            plotOutput("corr_plot", height = 250))))
                )
      )
    )
  )
)
