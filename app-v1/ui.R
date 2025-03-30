

ui<-function(request){

header <- dashboardHeaderPlus(
      title = "Climate-resilient reclamation",
      titleWidth = "20vw",
      enable_rightsidebar = F
  )
  
sidebar = dashboardSidebar(
  disable = FALSE,
  collapsed = FALSE,
  width = "20vw",
  sidebarMenu(
        id = "tabs",
        convertMenuItem(menuItem( style="background-color: #3e5b66; ",
          text = "1. Study area/data explorer",
          # icon = icon("globe-americas",lib = "font-awesome"),
          tabName = "tab1",
          selected = F,
          startExpanded = T,
          div(h4("Select Area of Interest", align = "center", style="font-family: Roboto; text-decoration: underline; padding-top: 1vh; ")),
          fluidRow( style="padding-left:1vmax; padding-right: 1vmax;",
                    radioGroupButtons(
                      inputId = "BoundarySel",
                      size = "normal",
                      direction = "vertical",
                      choices=c(
                        "Oil Sands Mineable Area" = "SurfaceMineableArea",
                        "AOESRP soil map" = "AOSERP_soils_bdr",
                        "Natural Subregions of Alberta" = "NSR_simpl"
                      ),
                      selected = "SurfaceMineableArea",
                      checkIcon = list(yes = icon("check")),
                      justified = T,
                      individual = T
                          ))
          ), 'tab1'),
        convertMenuItem(menuItem(
          text = "2. Vegetation responses to climate change (2018)",
          # icon = icon("globe-americas",lib = "font-awesome"),
          tabName = "tab2",
          selected = F,
          startExpanded = F,
          fluidRow(selectInput(
            inputId = "predType",
            label=p(icon("chart-line"),"Scenario"),
            selected="ab_veg_fm_c", 
            choices=c("Choose a scenario"="",
                      "Fire-mediated, constrained" = "ab_veg_fm_c",
                      "Fire-mediated, unconstrained" = "ab_veg_fm_uc",
                      "Climate Driven" = "Stralberg"
            ),
            multiple=F,
            width="100%"
          ),
          selectInput(
            inputId = "climScen",
            label=p(icon("chart-line"),"Future climate scenario"),
            selected="rcp85", 
            choices=c("Choose a climate scenario"="",
                      # "Baseline" ="actual",
                      # "R.C.P. 4.5" ="rcp45",
                      "R.C.P. 8.5" ="rcp85"
            ),
            multiple=F,
            width="100%"
          ),
          selectInput(
            inputId = "climMod",
            label=p(icon("chart-line"),"GCM"),
            selected="CanESM2", 
            choices=c("Choose a GCM"="",
                      # "combined"= "",
                      "CanESM2"= "CanESM2",
                      "CSIRO"= "CSIRO",
                      "HadGEM2"= "HadGEM2"
            ),
            multiple=F,
            width="100%"
            ),
          fluidRow(style = "float: right; margin-right: 30px; ",
                   plotOutput(outputId = "Tab2legend", height = "42vh", width = "15vw")))
          ),'tab2')#,
        # convertMenuItem(menuItem(
        #   text = "3. Item",
        #   # icon = icon("globe-americas",lib = "font-awesome"),
        #   tabName = "tab3",
        #   selected = F,
        #   startExpanded = F,
        #   br(),
        #   h5("some text"),
        #   br()
        # ),'tab3')
       )
    )
    
body = dashboardBody(
      # setShadow(class = "dropdown-menu"),
  tabItems(
    tabItem(
      tabName = "tab1",
      fluidRow(style = "padding-left: 0px; padding-top: 0px; padding-right: 0px; ",
                column(width = 10, style = "padding-left: 0px; padding-right: 0px; ",
                       uiOutput("MainMap")),
               column(width = 2, style = "padding-left: 0px; ",
                      # div(h4("Select summary graph", align = "center", style="font-family: Roboto; text-decoration: underline; font-size: 1vmax; ")),
                      selectInput(inputId="GraphSel",label="Select summary graph", multiple=F, selected="DEP", width = '100%',
                                  choices = c("Choose layer:" = "",
                                              "DEP",
                                              "Soils",
                                              "ABMI landcover")),
                      selectInput(inputId="NSRSel",label=NULL, multiple=F, selected="", width = '80%',
                                  choices = c("Choose NSR:" = "", MinableArea_NSR_list)),
                      uiOutput(("figuresUI")),
                      br(),
                      downloadBttn(outputId="DownloadData",
                                   label = "Download Summary Data",
                                   style="fill",
                                   color="success",
                                   size="md",
                                   no_outline=T)
                      )
               )
     ),
    tabItem(
      tabName = "tab2", 
      fluidRow(style = "padding-left: 0px; padding-top: 0px; padding-right: 0px; ",
               column(width = 10, style = "padding-left: 0px; padding-right: 0px; ",
                      fluidRow(
                        column(width = 6,
                             div(h1("Baseline", align = "center", style = "margin-top: 0px; padding-top: 0px;"),
                                 br()
                                 )),
                        column(width = 6,
                             div(h1("Future", align = "center", style = "margin-top: 0px; padding-top: 0px;"),
                                 h4(htmlOutput("future_text"), align = "center", style = "margin-top: 0px; padding-top: 0px; display: inline; ")
                                 ))),
                      uiOutput("Tab2MainMap")),
               column(width = 2, style = "padding-left: 0px; ",
                      selectInput(inputId="Tab2NSRSel",label=NULL, multiple=F, selected="", width = '80%',
                                  choices = c("Choose NSR:" = "", AB_VegChange_NSR_list)),
                      fluidRow(plotlyOutput(outputId = "Tab2Plot", height = "80vh")),
                      br(),
                      downloadBttn(outputId="Tab2DownloadData",
                                   label = "Download Summary Data",
                                   style="fill",
                                   color="success",
                                   size="md",
                                   no_outline=T)
                  )
               )
      )#,
    # tabItem(
    #   tabName = "tab3", h1("Project/App info"))
  )
)
  
# rightside = rightSidebar(
#     background = "dark",
#     rightSidebarTabContent(
#       id = "1",
#       title = "Tab 1",
#       icon = FALSE,
#       active = TRUE,
#       sliderInput(
#         "obs",
#         "Number of observations:",
#         min = 0, max = 1000, value = 500
#       )
#     )
#   )


dashboardPagePlus(
      tags$link(rel = "stylesheet", type = "text/css", href = "./customlegend9.css"),
      header = header,
      sidebar= sidebar,
      # rightsidebar = rightside,
      body = body,
      title = "Climate-Resilient Reclamation in Alberta",
      skin = "green"
      # sidebar_background = "dark",
      # sidebar_fullCollapse = F,
      # md = F
    )
    
}  


