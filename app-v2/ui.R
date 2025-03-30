

ui<-function(request){

convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  mi
} 

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
        convertMenuItem(menuItem(
          text = "Vegetation responses to climate change",
          tabName = "tab2",
          selected = F,
          startExpanded = T,
          fluidRow(selectInput(
            inputId = "predType",
            label=p(icon("chart-line"),"Scenario"),
            # selected="ab_veg_fm_c", 
            choices=Files$get_pred_types(),
            # choices=c("Choose a scenario"="", Files$get_pred_types()),
            # choices=c("Choose a scenario"="",
            #           "Fire-mediated, constrained" = "ab_veg_fm_c",
            #           "Fire-mediated, unconstrained" = "ab_veg_fm_uc",
            #           "Climate Driven" = "Stralberg"),
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
            # selected="CanESM2", 
            choices=Files$get_climate_models(),
            # choices=c("Choose a GCM"="", Files$get_climate_models()),
            # choices=c("Choose a GCM"="",
            #           # "combined"= "",
            #           "CanESM2"= "CanESM2",
            #           "CSIRO"= "CSIRO",
            #           "HadGEM2"= "HadGEM2"),
            multiple=F,
            width="100%"
            ),
          fluidRow(style = "float: right; margin-right: 30px; ",
                   plotOutput(outputId = "Tab2legend", height = "42vh", width = "15vw")))
          ),'tab2')
       )
    )

body = dashboardBody(
  tabItems(
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
                                  choices = c("Choose NSR:" = "", nsr_list)),
                      fluidRow(plotlyOutput(outputId = "Tab2Plot", height = "80vh"))#,
                      # br(),
                      # downloadBttn(outputId="Tab2DownloadData",
                      #              label = "Download Summary Data",
                      #              style="fill",
                      #              color="success",
                      #              size="md",
                      #              no_outline=T)
                  )
               )
      )
  )
)

dashboardPagePlus(
      header = header,
      sidebar= sidebar,
      body = body,
      title = "Climate-Resilient Reclamation in Alberta",
      skin = "green"
    )
}


