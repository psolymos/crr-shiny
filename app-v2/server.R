server <- function(input, output, session) {


# Tab2 ------------------

output$Tab2MainMap <- renderUI({


lng=-115
lat=55.4
zoom=6
  
Tab2Map1 = leaflet(
    padding = 0,
    height = "90vh",
    options = leafletOptions(
      attributionControl=FALSE,
      minZoom = minZoom,
      maxZoom = maxZoom,
      crs = leafletCRS(),
      worldCopyJump = F)) %>%
    setView(lng=lng, lat=lat, zoom = zoom)  %>%
    # fitBounds(extent(NSR_simpl)[1], extent(NSR_simpl)[3], extent(NSR_simpl)[2], extent(NSR_simpl)[4]) %>%
    addProviderTiles(
      provider = providers$Esri.WorldStreetMap,
      layerId = "ESRI Street",
      group = "ESRI Street",
      options = tileOptions(
        zIndex = 0.0,
        minZoom = minZoom,
        maxZoom = maxZoom,
        opacity = 1
      )
    ) %>%
  leafem::addCOG(
                url = paste0(fileserver_link, "base/Stralberg_baseline_vegeco4top_mod_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "Stralberg_baseline_vegeco4top_mod_prj_on",
                group = "Baseline ecosite (2018)") %>%
  leafem::addCOG(
                url = paste0(fileserver_link, "base/DEP_baselayer_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "DEP_baselayer_on",
                group = "DEP baseline") %>%
  leafem::addCOG(
                url = paste0(fileserver_link, "base/BaselineUpland_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "BaselineUpland_prj_on",
                group = "Mask lowland (2018 study)") %>%
  leafem::addCOG(
                url = paste0(fileserver_link, "base/PLC30_OS_100_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "PLC30_OS_100_prj_on",
                group = "Mask lowland (ABMI landcover)") %>%
  addLayersControl(overlayGroups = c("Mask lowland (2018 study)", "Mask lowland (ABMI landcover)"), 
                   baseGroups = c("Baseline ecosite (2018)", "DEP baseline"),
                   position = c("topright"),
                   options = layersControlOptions(collapsed = F)) %>% hideGroup("Mask lowland (2018 study)") %>% hideGroup("Mask lowland (ABMI landcover)")

  Tab2Map2 =   leaflet(
    padding = 0,
    height = "90vh",
    options = leafletOptions(
      attributionControl=FALSE,
      minZoom = minZoom,
      maxZoom = maxZoom,
      crs = leafletCRS(),
      worldCopyJump = F)) %>%
    setView(lng=lng, lat=lat, zoom = zoom)  %>%
    # fitBounds(extent(NSR_simpl)[1], extent(NSR_simpl)[3], extent(NSR_simpl)[2], extent(NSR_simpl)[4]) %>%
    addProviderTiles(
      provider = providers$Esri.WorldStreetMap,
      layerId = "ESRI Street",
      group = "ESRI Street",
      options = tileOptions(
        zIndex = 0.0,
        minZoom = minZoom,
        maxZoom = maxZoom,
        opacity = 1
      )
    ) %>%
  leafem::addCOG(
                url = paste0(
                  fileserver_link, 
                  switch(input$predType,
                    "ab_veg_fm_c" = "scenarios/fire-mediated-constrained/",
                    "ab_veg_fm_uc" = "scenarios/fire-mediated-unconstrained/",
                    "Stralberg" = "scenarios/climate-driven/"),
                  input$predType, "_20112040_",input$climMod,"_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "20112040",
                group = "2011-2040 Period") %>%
  leafem::addCOG(
                url = paste0(
                  fileserver_link, 
                  switch(input$predType,
                    "ab_veg_fm_c" = "scenarios/fire-mediated-constrained/",
                    "ab_veg_fm_uc" = "scenarios/fire-mediated-unconstrained/",
                    "Stralberg" = "scenarios/climate-driven/"),
                  input$predType, "_20412070_",input$climMod,"_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "20412070",
                group = "2041-2070 Period") %>%
  leafem::addCOG(
                url = paste0(
                  fileserver_link, 
                  switch(input$predType,
                    "ab_veg_fm_c" = "scenarios/fire-mediated-constrained/",
                    "ab_veg_fm_uc" = "scenarios/fire-mediated-unconstrained/",
                    "Stralberg" = "scenarios/climate-driven/"),
                  input$predType, "_20712100_",input$climMod,"_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "20712100",
                group = "2071-2100 Period") %>%
  leafem::addCOG(
                url = paste0(fileserver_link, "base/BaselineUpland_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "BaselineUpland_prj_on",
                group = "Mask lowland (2018 study)") %>%
  leafem::addCOG(
                url = paste0(fileserver_link, "base/PLC30_OS_100_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "PLC30_OS_100_prj_on",
                group = "Mask lowland (ABMI landcover)") %>%
    addLayersControl(overlayGroups = c("Mask lowland (2018 study)", "Mask lowland (ABMI landcover)"), 
                     baseGroups = c("2011-2040 Period", "2041-2070 Period", "2071-2100 Period"),
                     position = c("topright"),
                     options = layersControlOptions(collapsed = F)) %>%  hideGroup("Mask lowland (2018 study)") %>% hideGroup("Mask lowland (ABMI landcover)") %>%
    htmlwidgets::onRender("
      function(el, x) {
        var myMap = this;
        myMap.on('baselayerchange',
          function (e) {
            Shiny.onInputChange('my_map_tile', e.layer.groupname)
        })
    }")
  
  
  sync(Tab2Map1, Tab2Map2, ncol = 2)  
  
})


output$future_text <- renderText({ 
  ScenarioLabel = NULL
  if (input$predType=="ab_veg_fm_c") {
    ScenarioLabel="Fire-mediated, constrained"
  } else if (input$predType=="ab_veg_fm_uc") {
    ScenarioLabel="Fire-mediated, unconstrained"
  } else {
    ScenarioLabel="Climate Driven"
  }
  paste("<b>Scenario:</b>", ScenarioLabel, "  <b>CC scenario:</b>", input$climScen, "  <b>Model:</b>", input$climMod)
})



# Tab 2 Plot ecosite ----------------------------------------------------------------------------------------------------------------

output$Tab2Plot <- renderPlotly({
  
  
  if(is.null(input$my_map_tile)) {

    varname <- paste0("ecosite_Area_", input$predType, "_20112040_", input$climMod)
    varnameperc <- paste0("ecosite_Area_perc_", input$predType, "_20112040_", input$climMod)
    textPeriod <- paste0("2011-2040 Period")
    
  } else if(input$my_map_tile=="2011-2040 Period") {
    
    varname <- paste0("ecosite_Area_", input$predType, "_20112040_", input$climMod)
    varnameperc <- paste0("ecosite_Area_perc_", input$predType, "_20112040_", input$climMod)
    textPeriod <- paste0("2011-2040 Period")
    
  } else if(input$my_map_tile=="2041-2070 Period") {

    varname <- paste0("ecosite_Area_", input$predType, "_20412070_", input$climMod)
    varnameperc <- paste0("ecosite_Area_perc_", input$predType, "_20412070_", input$climMod)
    textPeriod <- paste0("2041-2070 Period")
    
  } else {

    varname <- paste0("ecosite_Area_", input$predType, "_20712100_", input$climMod)
    varnameperc <- paste0("ecosite_Area_perc_", input$predType, "_20712100_", input$climMod)
    textPeriod <- paste0("2071-2100 Period")
    
  }
  
  varname0 <- paste0("ecosite_Area_baseline")
  varname0perc <- paste0("ecosite_Area_perc_baseline")

  
if(is.null(input$Tab2NSRSel) | input$Tab2NSRSel=="" | input$Tab2NSRSel=="all NSRs") {
    
Tab2Plot0 =  AB_VegChange_NSR_summ %>% 
  group_by(ClassordNum, Classification, Color) %>% 
  summarize(ecosite_Area_NSR_all=sum(get(varname0), na.rm = T), .groups = 'keep') %>%
  ungroup() %>%
  mutate(ecosite_Area_perc_NSR_all=round(ecosite_Area_NSR_all/sum(ecosite_Area_NSR_all)*100, 0)) %>%
  plot_ly() %>% 
      add_trace(y=~as.factor(ClassordNum), x=~ecosite_Area_NSR_all, color =~as.factor(ClassordNum), colors=~Color,  width=0.9, name=~Classification, hovertext = ~paste0("NSR: all", "<br>", "Ecosite: ", Classification, "<br>", round(ecosite_Area_NSR_all, 0), " ha<br>", ecosite_Area_perc_NSR_all, "%"), 
                hoverinfo = 'text', showlegend=F, 
                type="bar", orientation = 'h') %>%
      layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
             xaxis = list(title = "Area (ha)"),
             margin = list(l=0),
             hovermode = 'y unified')

Tab2Plot1 =  AB_VegChange_NSR_summ %>% 
  group_by(ClassordNum, Classification, Color) %>% 
  summarize(ecosite_Area_NSR_all=sum(get(varname), na.rm = T), .groups = 'keep') %>%
  ungroup() %>%
  mutate(ecosite_Area_perc_NSR_all=round(ecosite_Area_NSR_all/sum(ecosite_Area_NSR_all)*100, 0)) %>%
  plot_ly() %>% 
  add_trace(y=~as.factor(ClassordNum), x=~ecosite_Area_NSR_all, color =~as.factor(ClassordNum), colors=~Color,  width=0.9, name=~Classification, hovertext = ~paste0("NSR: all", "<br>", "Ecosite: ", Classification, "<br>", round(ecosite_Area_NSR_all, 0), " ha<br>", ecosite_Area_perc_NSR_all, "%"), 
            hoverinfo = 'text', showlegend=F, 
            type="bar", orientation = 'h') %>%
  layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
         xaxis = list(title = "Area (ha)"),
         margin = list(l=0),
         hovermode = 'y unified')


subplot(list(Tab2Plot0, Tab2Plot1), shareX = T, titleX = T, nrows=2, heights= c(0.5, 0.5)) %>% 
  layout(annotations = list(
    list(x = 0.5 , y = 0.999, text = sprintf("<b>%s</b>", "Baseline"), font = list(size=15), showarrow = F, xref='paper', yref='paper'),
    list(x = 0.5 , y = 0.499, text = sprintf("<b>%s</b>", textPeriod), font = list(size=15), showarrow = F, xref='paper', yref='paper')))


  } else  { 
    
Tab2Plot3 <- subset(AB_VegChange_NSR_summ, NSRNAME==input$Tab2NSRSel) %>% 
  plot_ly() %>% 
  add_trace(y=~as.factor(ClassordNum), x=as.formula(paste0("~", varname0)), color =~as.factor(ClassordNum), colors=~Color, width=0.9, name=~Classification, hovertext = ~paste0("Ecosite: ", Classification, "<br>", round(get(varname0), 0), " ha<br>", round(get(varname0perc), 0), "%"), 
                hoverinfo = 'text', showlegend=F, 
                type="bar", orientation = 'h') %>%
      layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
             xaxis = list(title = "Area (ha)"),
             margin = list(l=0),
             hovermode = 'y unified')
    
Tab2Plot4 <- subset(AB_VegChange_NSR_summ, NSRNAME==input$Tab2NSRSel) %>% 
  plot_ly() %>% 
  add_trace(y=~as.factor(ClassordNum), x=as.formula(paste0("~", varname)), color =~as.factor(ClassordNum), colors=~Color, width=0.9, name=~Classification, hovertext = ~paste0("Ecosite: ", Classification, "<br>", round(get(varname), 0), " ha<br>", round(get(varnameperc), 0), "%"), 
            hoverinfo = 'text', showlegend=F, 
            type="bar", orientation = 'h') %>%
  layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
         xaxis = list(title = "Area (ha)"),
         margin = list(l=0),
         hovermode = 'y unified')

subplot(list(Tab2Plot3, Tab2Plot4), shareX = T, titleX = T, nrows=2, heights= c(0.5, 0.5)) %>% 
      layout(annotations = list(
        list(x = 0.5 , y = 0.999, text = sprintf("<b>%s</b>", "Baseline"), font = list(size=15), showarrow = F, xref='paper', yref='paper'),
        list(x = 0.5 , y = 0.499, text = sprintf("<b>%s</b>", textPeriod), showarrow = F, xref='paper', yref='paper')))
    
  }
})

# Tab 2 Legend --------------------
output$Tab2legend <- renderPlot({
  
  par(mar=c(0,0,0,0))
  legend = plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend(x=0.2, y=1.03, legend =AB_VegChange_classes$Classification, pch=15, pt.cex=1.45, cex=0.60, bty='n',
         col = AB_VegChange_classes$Color)
  
})





}

