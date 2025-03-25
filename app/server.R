server <- function(input, output, session) {

  
  # to delete later
# observeEvent(input$keypressed,
#                {
#                  if(input$keypressed==27)
#                    stopApp()
#                })

# Tab 1 ----------
  
# Main Map --------------------------------------------------------------------------------------------------------------
  
BoundaryReaVal <- reactiveValues(BoundaryReaSel = NULL)

  observe({
    BoundaryReaVal$BoundaryReaSel <- input$BoundarySel
  })
  
output$MainMap <- renderUI({

  data <- BoundaryReaVal$BoundaryReaSel

  MainMap1 = leaflet(
    padding = 0,
    height = "90vh",
    options = leafletOptions(
      attributionControl=FALSE,
      minZoom = minZoom,
      maxZoom = maxZoom,  
      crs = leafletCRS(),
      worldCopyJump = F)) %>%
    fitBounds(extent(SurfaceMineableArea)[1], extent(SurfaceMineableArea)[3], extent(SurfaceMineableArea)[2], extent(SurfaceMineableArea)[4]) %>%
    addScaleBar(
      position = c("bottomleft"),
      options = scaleBarOptions(maxWidth = 250, imperial = F)
    ) %>%
    addMiniMap(
      minimized = T,
      toggleDisplay = T,
      collapsedWidth = 50,
      collapsedHeight = 50
    ) %>%
    addProviderTiles(
      provider = providers$Stamen.Terrain,
      group = "Terrain",
      layerId = "Toner Lite",
      options = tileOptions(
        zIndex = -1,
        minZoom = minZoom,
        maxZoom = maxZoom
      )
    ) %>%
    addProviderTiles(
      provider = "OpenStreetMap.Mapnik",
      group = "Street Map",
      layerId = "OSM Mapnik",
      options = tileOptions(
        zIndex = -1,
        minZoom = minZoom,
        maxZoom = maxZoom
      )
    ) %>%
    addProviderTiles(
      provider = providers$Esri.WorldImagery,
      layerId = "Imagery",
      group = "ESRI Imagery",
      options = tileOptions(
        zIndex = 0.0,
        minZoom = minZoom,
        maxZoom = maxZoom,
        opacity = 1
      )
    ) %>%
    addWMSTiles(NRCan_GeoGratis_CBMT_link,
                layers = "CBMT",
                attribution="NRCan GeoGratis",
                group = "NRCan GeoGratis (CBMT)",
                options = WMSTileOptions(format = "image/png", transparent = T, zIndex = -1, minZoom = minZoom, maxZoom = maxZoom, opacity = 1)) %>%
    addPolygons(
      data = NSR_simpl,
      group = "Natural Subregions of Alberta",
      fill = T,
      fillColor = ~palNSR(NSR_simpl$NSRNAME), 
      fillOpacity = 0.5,
      opacity = 1,
      weight = 2,
      color = "black",
      stroke = T,
      smoothFactor = 0.5,
      label= ~paste0('NSR: ', NSR_simpl$NSRNAME))  %>%
    addLayersControl(
      position = c("topright"),
      baseGroups = c("ESRI Imagery", "Street Map", "Stamen", "NRCan GeoGratis (CBMT)"),
      overlayGroups = c("Natural Subregions of Alberta"),
      options = layersControlOptions(collapsed = F, autoZIndex = F))  %>% hideGroup("Natural Subregions of Alberta")



  MainMap2 =     leaflet(
    padding = 0,
    height = "90vh",
    options = leafletOptions(
      attributionControl=FALSE,
      minZoom = minZoom,
      maxZoom = maxZoom,
      crs = leafletCRS(),
      worldCopyJump = F)) %>%
    fitBounds(extent(SurfaceMineableArea)[1], extent(SurfaceMineableArea)[3], extent(SurfaceMineableArea)[2], extent(SurfaceMineableArea)[4]) %>%
    addWMSTiles(NRCan_GeoGratis_CBMT_link,
                layers = "CBMT",
                attribution="NRCan GeoGratis",
                group = "NRCan GeoGratis (CBMT)",
                options = WMSTileOptions(format = "image/png", transparent = T, zIndex = -1, minZoom = minZoom, maxZoom = maxZoom, opacity = 1))    %>%
  #WMS
  # addWMSTiles(baseUrl = geoserver_link,
  #             layers= c("DEP_baselayer_on"),
  #             attribution="CFS NRCAN",
  #             options = WMSTileOptions(
  #               opacity = 1,transparent = T,format="image/png"),
  #             group = "Derived Ecosite Phase") %>%
  #WMS
  #COG
  leafem::addCOG(
                url = paste0(fileserver_link, "base/DEP_baselayer_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "DEP_baselayer_on",
                group = "Derived Ecosite Phase") %>%
  #COG
    addRasterImage(
    x = raster("./data/DEP_PROJleaflet.tif"),
    colors = colorFactor(DEP_classes_map$Color, domain = DEP_classes_map$RasterNum, levels = NULL, ordered = FALSE, na.color = "#00000000", alpha = FALSE, reverse = FALSE),
    opacity = 1,
    maxBytes=2000*1024*1024,
    project=F,
    group = "Derived Ecosite Phase (Old)") %>%
  # addLegend(position = "topright",
  #             colors = subset(DEP_classes, X!=29 & X!=31)$Color,
  #             labels = subset(DEP_classes, X!=29 & X!=31)$StralbergName,
  #             opacity = 1,
  #             className = "mySpecialLegend mySpecialLegendDEP i",
  #             title = "DEP",
  #             layerId = "Derived Ecosite Phase Legend",
  #             group = "Derived Ecosite Phase") %>%
  #WMS
    # addWMSTiles(baseUrl = geoserver_link,
    #           layers= c("PLC30_OS_100_col"),
    #           attribution="CFS NRCAN",
    #           group = "ABMI predictive landcover (3.0)",
    #           options = WMSTileOptions(opacity = 1, format = "image/png", transparent = TRUE)) %>%
  #WMS
  #COG
  leafem::addCOG(
                url = paste0(fileserver_link, "base/PLC30_OS_100_col.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "PLC30_OS_100_col",
                group = "ABMI predictive landcover (3.0)") %>%
  #COG
   # addLegend(position = "topright",
   #            colors = c("#08306b", "#FEE391","#ADDD8E", "#8C510A", "#858F30", "#006D2C", "#F0AA45"),
   #            labels = c("Open water", "Fen", "Bog", "Marsh", "Swamp", "Upland", "Wetland general"),
   #            opacity = 1,
   #            title = "ABMI predictive landcover",
   #            layerId = "ABMI predictive landcover (3.0) Legend",
   #            group = "ABMI predictive landcover (3.0)") %>%
    addLayersControl(overlayGroups = c("ABMI predictive landcover (3.0)", "Derived Ecosite Phase", "Derived Ecosite Phase (Old)"), 
                     position = c("topright"),
                     options = layersControlOptions(collapsed = F)) %>% hideGroup("ABMI predictive landcover (3.0)")  %>% hideGroup("Derived Ecosite Phase (Old)") 
  
if(startsWith(data,"SurfaceMineableArea")) {

mm1 = MainMap1 %>%
        clearGroup("Boundary") %>%
        removeControl("Layer Legend")%>%
        fitBounds(extent(SurfaceMineableArea)[1], extent(SurfaceMineableArea)[3], extent(SurfaceMineableArea)[2], extent(SurfaceMineableArea)[4]) %>%
        addHomeButton(extent(SurfaceMineableArea), group = "Study area extent", position = "topleft") %>%
        addMapPane("zBoundary", zIndex = 1000) %>%
        addPolygons(
          data = SurfaceMineableArea,
          group = "Boundary",
          fill = FALSE,
          opacity = 1,
          weight = 5,
          color = "black",
          stroke = T,
          smoothFactor = 0.5,
          options = pathOptions(pane = "zBoundary"),
          label= ~htmlEscape(paste0('Oil Sands Mineable Area'))) 
      
mm2 = MainMap2 %>%
        clearGroup("Boundary") %>%
        removeControl("Layer Legend")%>%
        fitBounds(extent(SurfaceMineableArea)[1], extent(SurfaceMineableArea)[3], extent(SurfaceMineableArea)[2], extent(SurfaceMineableArea)[4]) %>%
        addPolygons(
          data = SurfaceMineableArea,
          group = "Boundary",
          fill = FALSE,
          opacity = 1,
          weight = 5,
          color = "black",
          stroke = T,
          smoothFactor = 0.5,
          label= ~htmlEscape(paste0('Oil Sands Mineable Area'))
        ) %>%
        addLegend(position = "bottomright",
                  title = NA,
                  colors = paste0(c("white"), "; border:3px solid black; background-color:rgba(255, 255, 255, 0.2); width: 30px; height: 30px"),
                  labels = c("Oil Sands Minable Area"),
                  opacity = 1,
                  className = "mySpecialLegend mySpecialLegend1 i",
                  layerId = "Layer Legend",
                  group = "Layer Legend")

sync(mm1, mm2, ncol = 2)  

      
 } else if(startsWith(data,"AOSERP_soils_bdr")) {

      mm1=   MainMap1 %>%
        clearGroup("Boundary") %>%
        removeControl("Layer Legend")%>%
        fitBounds(extent(AOSERP_soils_bdr)[1], extent(AOSERP_soils_bdr)[3], extent(AOSERP_soils_bdr)[2], extent(AOSERP_soils_bdr)[4]) %>%
        addHomeButton(extent(AOSERP_soils_bdr), group = "Study area extent", position = "topleft") %>%
        addMapPane("zBoundary", zIndex = 1000) %>%
        addPolygons(
          data = AOSERP_soils_bdr,
          group = "Boundary",
          fill = FALSE,
          opacity = 1,
          weight = 5,
          color = "black",
          stroke = T,
          smoothFactor = 0.5,
          options = pathOptions(pane = "zBoundary"),
          label= ~paste0('AOSERP Area'))  
      
      mm2=   MainMap2 %>%
        clearGroup("Boundary") %>%
        removeControl("Layer Legend")%>%
        fitBounds(extent(AOSERP_soils_bdr)[1], extent(AOSERP_soils_bdr)[3], extent(AOSERP_soils_bdr)[2], extent(AOSERP_soils_bdr)[4]) %>%
        addPolygons(
          data = AOSERP_soils_bdr,
          group = "Boundary",
          fill = FALSE,
          opacity = 1,
          weight = 5,
          color = "black",
          stroke = T,
          smoothFactor = 0.5,
          label= ~paste0('AOSERP Area')) %>%
        addLegend(position = "bottomright",
                  title = NA,
                  colors = paste0(c("white"), "; border:3px solid black; background-color:rgba(255, 255, 255, 0.2); width: 30px; height: 30px; "),
                  labels = c("AOSERP area"),
                  opacity = 1,
                  className = "mySpecialLegend mySpecialLegend1 i",
                  layerId = "Layer Legend",
                  group = "Layer Legend")
  sync(mm1, mm2, ncol = 2)  

} else {

      lng=-115
      lat=55.4
      zoom=6

      mm1=   MainMap1 %>%
        clearGroup("Boundary") %>%
        removeControl("Layer Legend")%>%
        fitBounds(extent(NSR_simpl)[1], extent(NSR_simpl)[3], extent(NSR_simpl)[2], extent(NSR_simpl)[4]) %>%
        addHomeButton(extent(NSR_simpl), group = "Study area extent", position = "topleft") %>%
        # addMapPane("zBoundary", zIndex = 1000) %>%
        addPolygons(
          data = NSR_simpl,
          group = "Boundary",
          fill = F,
          opacity = 1,
          weight = 2,
          color = "black",
          stroke = T,
          # options = pathOptions(pane = "zBoundary"),
          smoothFactor = 0.5) 
      
      mm2=   MainMap2 %>%
        clearGroup("Boundary") %>%
        removeControl("Layer Legend")%>%
        fitBounds(extent(NSR_simpl)[1], extent(NSR_simpl)[3], extent(NSR_simpl)[2], extent(NSR_simpl)[4]) %>%
        addPolygons(
          data = NSR_simpl,
          group = "Boundary",
          fill = F,
          opacity = 1,
          weight = 2,
          color = "black",
          stroke = T,
          smoothFactor = 0.5) %>%
        addLegend(position = "bottomright",
                  title = NA,
                  colors = paste0(c("white"), "; border:3px solid black; background-color:rgba(255, 255, 255, 0.2); width: 30px; height: 30px"),
                  labels = c("Natural Subregions of Alberta"),
                  opacity = 1,
                  className = "mySpecialLegend mySpecialLegend1 i",
                  layerId = "Layer Legend",
                  group = "Layer Legend") 
     
 sync(mm1, mm2, ncol = 2)  
      
    }
    
  })



# UI for figures  ---------------------
output$figuresUI = renderUI({
  data <- BoundaryReaVal$BoundaryReaSel
    if (input$GraphSel=="DEP") {
      
     div(
       fluidRow(plotlyOutput(outputId = "Plot3", height = "40vh")),
       h5("Note: Below legend is for 'Derived Ecosite Phase (Old)' layer"),
       fluidRow(plotOutput(outputId = "Plot4", height = "40vh", width = "13vw"))
     )
      
    } else if (input$GraphSel=="ABMI landcover") {

      div(
        fluidRow(plotlyOutput(outputId = "Plot2", height = "40vh")),
        fluidRow(plotOutput(outputId = "Plot5", height = "20vh", width = "13vw"))
      )
      
    } else {
      
      div(
        fluidRow(plotlyOutput(outputId = "Plot1", height = "40vh")),
        fluidRow(plotOutput(outputId = "Plot6", height = "20vh", width = "13vw"))
      )
      
    }
    
})


# Plot 1 Soils ----------------------------------------------------------------------------------------------------------------

output$Plot1 <- renderPlotly({
  data <- BoundaryReaVal$BoundaryReaSel
  Soil_texture_colors = c("#003249", "#0f7173","#70C1B3", "#FFE066", "#F25F5C", "#4f0147", "#50514F")
  
  if(startsWith(data,"SurfaceMineableArea")) {
    
    plot1_dataset = AOSERP_soils_MinableArea_summ
    
  } else if(startsWith(data,"AOSERP_soils_bdr")) {
    
    plot1_dataset = AOSERP_soils_Soil_summ
    
  } else {
    
    plot1_dataset = AOSERP_soils_NSR_summ
    
  }
  
  if(is.null(input$NSRSel) | input$NSRSel=="" | input$NSRSel=="all NSRs") {
    
    plot1_dataset %>% 
      plot_ly() %>% 
      group_by(Txtrcls) %>%
      mutate(texture_Areaha_all=round(sum(texture_Areaha, na.rm = T),1))   %>% 
      mutate(texture_Areaha_perc_all=round(sum(texture_Areaha, na.rm = T)/sum(plot1_dataset$texture_Areaha, na.rm = T)*100,1))   %>%
      distinct(Txtrcls, .keep_all = T)%>% 
      add_trace(y=~Txtrcls_num, x=~texture_Areaha_all ,
                type="bar", orientation = 'h',  marker=list(color=Soil_texture_classes$color),
                text = ~paste0("NSR: all<br>", "Soil texture: ", Txtrcls, "<br>", round(texture_Areaha_all, 0), " ha<br>", texture_Areaha_perc_all, "%"), 
                hoverinfo = 'text', showlegend=F) %>%
      layout(yaxis = list(title = "", showticklabels = F, autorange="reversed"),
             xaxis = list(title = "Area by texture class <br>within selected boundary (ha)"),
             legend = list(orientation = 'h'),
             margin = list(l=0),
             barmode = 'stack')
    
  } else  { 

    subset(plot1_dataset, NSRNAME==input$NSRSel) %>% 
      plot_ly() %>% 
      add_trace(y=~Txtrcls_num, x=~texture_Areaha ,
                type="bar", orientation = 'h',  marker=list(color=Soil_texture_classes$color),
                name=~NSRNAME, text = ~paste0("NSR: ", NSRNAME, "<br>", "Soil texture: ", Txtrcls, "<br>", round(texture_Areaha, 0), " ha<br>", texture_Areaha_perc, "%"), 
                hoverinfo = 'text', showlegend=F) %>%
      layout(yaxis = list(title = "", showticklabels = F, autorange="reversed"),
             xaxis = list(title = "Area by texture class <br>within selected boundary (ha)"),
             legend = list(orientation = 'h'),
             margin = list(l=0),
             barmode = 'stack')
    
    # subset(plot1_dataset, NSRNAME==input$NSRSel) %>% 
    #   plot_ly() %>% 
    #   add_pie(labels=~Txtrcls, values=~texture_Areaha, type="pie",
    #           textinfo='label+percent', insidetextorientation="horizontal",
    #           insidetextfont=list(color="#FFFFFF"),
    #           showlegend=F, legendgroup=~Txtrcls,
    #           marker=list(colors=c("#5C9B84","#4D4E4D", "#B4B1B1"),
    #                       line=list(color= "#FFFFFF", width=1)))  %>%
    #   layout(title = "Area by texture class <br>within selected boundary (%)",
    #          margin = list(l=0))
    
  }
})

# Plot 2 Landcover ----------------------------------------------------------------------------------------------------------------

output$Plot2 <- renderPlotly({
  data <- BoundaryReaVal$BoundaryReaSel

    if(startsWith(data,"SurfaceMineableArea")) {
    
    plot2_dataset = PLC30_OS_100_MinableArea_summ
    
  } else if(startsWith(data,"AOSERP_soils_bdr")) {
    
    plot2_dataset = PLC30_OS_100_Soil_summ
    
  } else {
    
    plot2_dataset = PLC30_OS_100_NSR_summ
    
  }
  
  if(is.null(input$NSRSel) | input$NSRSel=="" | input$NSRSel=="all NSRs") {
    
    plot2_dataset %>% 
      group_by(Landcover_class) %>%
      mutate(PLC_Area_all=round(sum(PLC_Area, na.rm = T),1))   %>% 
      mutate(PLC_Area_perc_all=round(sum(PLC_Area, na.rm = T)/sum(plot2_dataset$PLC_Area, na.rm = T)*100,1))   %>%
      distinct(Landcover_class, .keep_all = T)%>% 
      plot_ly() %>% 
      add_trace(y=~Landcover_class, x=~PLC_Area_all,
                type="bar", orientation = 'h', marker=list(color=LC_ABMI_colors), text = ~paste0("NSR: all", "<br>", "Landcover class: ", Landcover_class_name, "<br>", round(PLC_Area_all, 0), " ha<br>", PLC_Area_perc_all, "%"), hoverinfo = 'text', showlegend=F) %>%
      layout(yaxis = list(title = "", showticklabels = F, autorange="reversed"),
             xaxis = list(title = "Area within selected boundary (ha)"),
             legend = list(orientation = 'h'),
             margin = list(l=0))
    
  } else  { 
    
    subset(plot2_dataset, NSRNAME==input$NSRSel) %>% 
      plot_ly() %>% 
      add_trace(y=~Landcover_class, x=~PLC_Area,
                type="bar", orientation = 'h', marker=list(color=LC_ABMI_colors),
                name=~NSRNAME, text = ~paste0("NSR: ", NSRNAME, "<br>", "Landcover class: ", Landcover_class_name, "<br>", round(PLC_Area, 0), " ha<br>", PLC_Area_perc, "%"), 
                hoverinfo = 'text', showlegend=F) %>%
      layout(yaxis = list(title = "", showticklabels = F, autorange="reversed"),
             xaxis = list(title = "Area within selected boundary (ha)"),
             legend = list(orientation = 'h'),
             margin = list(l=0),
             barmode = 'stack')
    
  }
})


# Plot 3 DEP ----------------------------------------------------------------------------------------------------------------

output$Plot3 <- renderPlotly({
  data <- BoundaryReaVal$BoundaryReaSel
  
  if(startsWith(data,"SurfaceMineableArea")) {
    
    plot3_dataset = DEP_MinableArea_summ
    
  } else if(startsWith(data,"AOSERP_soils_bdr")) {
    
    plot3_dataset = DEP_Soil_summ
    
  } else {
    
    plot3_dataset = DEP_NSR_summ
    
  }
    
  if(is.null(input$NSRSel) | input$NSRSel=="" | input$NSRSel=="all NSRs") {
    
    plot3_dataset %>% 
      group_by(DEP_ecosite) %>%
      mutate(DEP_Area_perc_all=round(sum(DEP_Area, na.rm = T)/sum(plot3_dataset$DEP_Area, na.rm = T)*100,1))   %>% 
    plot_ly() %>% 
      add_trace(y=~as.factor(DEPordNum), x=~DEP_Area, color =~as.factor(DEPordNum), colors=~Color,  width=0.9, name=~Classification , text = ~paste0("NSR: all", "<br>", "Ecosite: ", Classification , "<br>", round(DEP_Area, 0), " ha<br>", DEP_Area_perc_all, "%"), 
                hoverinfo = 'text', showlegend=F, 
                type="bar", orientation = 'h') %>%
      layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
             xaxis = list(title = "Area within selected boundary (ha)"),
             margin = list(l=0))
    
  } else  { 
    
    subset(plot3_dataset, NSRNAME==input$NSRSel) %>% 
      plot_ly() %>% 
      add_trace(y=~as.factor(DEPordNum), x=~DEP_Area, color =~as.factor(DEPordNum), colors=~Color, width=0.9, name=~Classification , text = ~paste0("Ecosite: ", Classification , "<br>", round(DEP_Area, 0), " ha<br>", DEP_Area_perc, "%"), 
                hoverinfo = 'text', showlegend=F, 
                type="bar", orientation = 'h') %>%
      layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
             xaxis = list(title = "Area within selected boundary (ha)"),
             margin = list(l=0))
    
  }
})



# Plot 4-6 Legend ----------------------------------------------------------------------------------------------------------------

output$Plot4 <- renderPlot({
  
  par(mar=c(0,0,0,0))
  legend = plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend(x=0, y=1.03, legend =DEP_classes$StralbergName, pch=15, pt.cex=1.65, cex=0.65, bty='n',
         col = DEP_classes$Color)

})

output$Plot5 <- renderPlot({

  par(mar=c(0,0,0,0))
  legend = plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend(x=0, y=1, legend =LC_ABMI_classes$LC_class, pch=15, pt.cex=2.4, cex=1.2, bty='n',
         col = LC_ABMI_classes$color)

})

output$Plot6 <- renderPlot({
  
  par(mar=c(0,0,0,0))
  legend = plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
  legend(x=0, y=1, legend =Soil_texture_classes$txt_class, pch=15, pt.cex=2.4, cex=1.2, bty='n',
         col = Soil_texture_classes$color)
  
})

# Dropdown update ------------------------------------------------------------------------------------------------------
# observeEvent(input$BoundarySel,{
#   foo<-input$BoundarySel
#   if(foo=="NSR_simpl"){
#     updateSelectInput(session,inputId="NSRSel", choices = c("Choose NSR:" = "", LandcoverArea_NSR_list), selected="")
#     updateSelectInput(session,inputId="GraphSel", selected="DEP")
#   } else if(foo=="AOSERP_soils_bdr"){
#     updateSelectInput(session,inputId="NSRSel", choices = c("Choose NSR:" = "", SoilArea_NSR_list), selected="")
#     updateSelectInput(session,inputId="GraphSel", selected="DEP")
#   } else if(input$GraphSel=="ABMI landcover"){
#     updateSelectInput(session,inputId="NSRSel", choices = c("Choose NSR:" = "", MinableArea_NSR_list1), selected="")
#     updateSelectInput(session,inputId="GraphSel", selected="DEP")
#   } else {
#     updateSelectInput(session,inputId="NSRSel", choices = c("Choose NSR:" = "", MinableArea_NSR_list), selected="")
#     updateSelectInput(session,inputId="GraphSel", selected="DEP")
#   }
# })
# 
# observeEvent(input$GraphSel,{
#   if(input$GraphSel=="DEP"){
#     updateSelectInput(session,inputId="NSRSel", selected="")
#   } else if(input$GraphSel=="Soils"){
#     updateSelectInput(session,inputId="NSRSel", selected="")
#   } else {
#     updateSelectInput(session,inputId="NSRSel", selected="")
#   }
# })

# Download button -----------------------------------------------------------------------------------------------------

output$DownloadData <- downloadHandler(
  
  filename = function() {
    
  if(input$BoundarySel=="SurfaceMineableArea") { 
    if(input$GraphSel=="DEP") {
       paste('DEP_by_MinableArea', '.csv', sep='')
    } else if(input$GraphSel=="Soils") {
      {paste('Soils_by_MinableArea', '.csv', sep='')}
    } else {
      {paste('Landcover_by_MinableArea', '.csv', sep='')}
    }
  } else if(input$BoundarySel=="AOSERP_soils_bdr") {
    if(input$GraphSel=="DEP") {
     {paste('DEP_by_AOSERParea', '.csv', sep='')}
    } else if(input$GraphSel=="Soils") {
     {paste('Soils_by_AOSERParea', '.csv', sep='')}
    } else {
       {paste('Landcover_by_AOSERParea', '.csv', sep='')}
    }
  } else {
    if(input$GraphSel=="DEP") {
      {paste('DEP_by_NSR', '.csv', sep='')}
    } else if(input$GraphSel=="Soils") {
      {paste('Soils_by_NSR', '.csv', sep='')}
    } else {
       {paste('Landcover_by_NSR', '.csv', sep='')}
    }
  }
},
content = function(con) {
  
  if(input$BoundarySel=="SurfaceMineableArea") { 
    if(input$GraphSel=="DEP") {
      write.csv(DEP_MinableArea_summ, con)
    } else if(input$GraphSel=="Soils") {
       {write.csv(AOSERP_soils_MinableArea_summ, con)}
    } else {
       {write.csv(PLC30_OS_100_MinableArea_summ, con)}
    }
  } else if(input$BoundarySel=="AOSERP_soils_bdr") {
    if(input$GraphSel=="DEP") {
       {write.csv(DEP_Soil_summ, con)}
    } else if(input$GraphSel=="Soils") {
      {write.csv(AOSERP_soils_Soil_summ, con)}
    } else {
       {write.csv(PLC30_OS_100_Soil_summ, con)}
    }
  } else {
    if(input$GraphSel=="DEP") {
      {write.csv(DEP_NSR_summ, con)}
    } else if(input$GraphSel=="Soils") {
       {write.csv(AOSERP_soils_NSR_summ, con)}
    } else {
      {write.csv(PLC30_OS_100_NSR_summ, con)}
    }
  }
}

)




# Tab2 ------------------

output$Tab2MainMap <- renderUI({
  
# output$Tab2MainMap1 <- renderLeaflet({
  
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
  #WMS
    # addWMSTiles(baseUrl = geoserver_link,
    #             layers= c("Stralberg_baseline_vegeco4top_mod_prj_on"),
    #             attribution="CFS NRCAN",
    #             options = WMSTileOptions(
    #               opacity = 1,transparent = T,format="image/png"),
    #             group = "Baseline ecosite (2018)") %>%
  #WMS
  #COG
  leafem::addCOG(
                url = paste0(fileserver_link, "base/Stralberg_baseline_vegeco4top_mod_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "Stralberg_baseline_vegeco4top_mod_prj_on",
                group = "Baseline ecosite (2018)") %>%
  #COG
  #WMS
  # addWMSTiles(baseUrl = geoserver_link,
  #             layers= c("DEP_baselayer_on"),
  #             attribution="CFS NRCAN",
  #             options = WMSTileOptions(
  #               opacity = 1,transparent = T,format="image/png"),
  #             group = "DEP baseline") %>%
  #WMS
  #COG
  leafem::addCOG(
                url = paste0(fileserver_link, "base/DEP_baselayer_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "DEP_baselayer_on",
                group = "DEP baseline") %>%
  #COG
  # addRasterImage(
  #     x = raster("./data/AB_VegChange/BaselineVeg/Stralberg_baseline_vegeco4top_mod_prj.tif"),
  #     colors = colorFactor(AB_VegChange_classes_map$Color, domain = AB_VegChange_classes_map$Code, levels = NULL, ordered = FALSE, na.color = "#00000000", alpha = FALSE, reverse = FALSE),
  #     opacity = 1,
  #     maxBytes=2000*1024*1024,
  #     project=F,
  #     group = "VegChange Baseline")  %>%
  #WMS
    # addWMSTiles(baseUrl = geoserver_link,
    #             layers= c("BaselineUpland_prj_on"),
    #             attribution="CFS NRCAN",
    #             options = WMSTileOptions(
    #               opacity = 1,transparent = T,format="image/png"),
    #             group = "Mask lowland (2018 study)") %>%
  #WMS
  #COG
  leafem::addCOG(
                url = paste0(fileserver_link, "base/BaselineUpland_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "BaselineUpland_prj_on",
                group = "Mask lowland (2018 study)") %>%
  #COG
    # addRasterImage(
    #   x = raster("./data/AB_VegChange/BaselineVeg/BaselineUpland_prj.tif"),
    #   colors = c("grey90", NA),
    #   opacity = 1,
    #   maxBytes=2000*1024*1024,
    #   project=F,
    #   group = "Mask lowland")  %>%
  #WMS
  # addWMSTiles(baseUrl = geoserver_link,
  #             layers= c("PLC30_OS_100_prj_on"),
  #             attribution="CFS NRCAN",
  #             options = WMSTileOptions(
  #               opacity = 1,transparent = T,format="image/png"),
  #             group = "Mask lowland (ABMI landcover)") %>%
  #WMS
  #COG
  leafem::addCOG(
                url = paste0(fileserver_link, "base/PLC30_OS_100_prj_on.tif"),
                rgb = TRUE,
                attribution="CFS NRCAN",
                layerId = "PLC30_OS_100_prj_on",
                group = "Mask lowland (ABMI landcover)") %>%
  #COG
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
  #WMS
    # addWMSTiles(baseUrl = geoserver_link,
    #             layers= c(paste0(input$predType,"_", "20112040","_",input$climMod,"_prj_on")),
    #             attribution="CFS NRCAN",
    #             options = WMSTileOptions(
    #               opacity = 1,transparent = T,format="image/png"),
    #             group = "2011-2040 Period") %>%
    # addWMSTiles(baseUrl = geoserver_link,
    #             layers= c(paste0(input$predType,"_", "20412070","_",input$climMod,"_prj_on")),
    #             attribution="CFS NRCAN",
    #             options = WMSTileOptions(
    #               opacity = 1,transparent = T,format="image/png"),
    #             group = "2041-2070 Period") %>%
    # addWMSTiles(baseUrl = geoserver_link,
    #             layers= c(paste0(input$predType,"_", "20712100","_",input$climMod,"_prj_on")),
    #             attribution="CFS NRCAN",
    #             options = WMSTileOptions(
    #               opacity = 1,transparent = T,format="image/png"),
    #             group = "2071-2100 Period") %>%
  #WMS
  #COG
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
  #COG
    # addRasterImage(
    #   x = raster("./data/AB_VegChange/BaselineVeg/BaselineUpland_prj.tif"),
    #   colors = c("grey90", NA),
    #   opacity = 1,
    #   maxBytes=2000*1024*1024,
    #   project=F,
    #   group = "Mask lowland")  %>%
  #WMS
    # addWMSTiles(baseUrl = geoserver_link,
    #             layers= c("BaselineUpland_prj_on"),
    #             attribution="CFS NRCAN",
    #             options = WMSTileOptions(
    #               opacity = 1,transparent = T,format="image/png"),
    #             group = "Mask lowland (2018 study)") %>%
    # addWMSTiles(baseUrl = geoserver_link,
    #             layers= c("PLC30_OS_100_prj_on"),
    #             attribution="CFS NRCAN",
    #             options = WMSTileOptions(
    #               opacity = 1,transparent = T,format="image/png"),
    #             group = "Mask lowland (ABMI landcover)") %>%
  #WMS
  #COG
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
  #COG
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
      add_trace(y=~as.factor(ClassordNum), x=~ecosite_Area_NSR_all, color =~as.factor(ClassordNum), colors=~Color,  width=0.9, name=~Classification, text = ~paste0("NSR: all", "<br>", "Ecosite: ", Classification, "<br>", round(ecosite_Area_NSR_all, 0), " ha<br>", ecosite_Area_perc_NSR_all, "%"), 
                hoverinfo = 'text', showlegend=F, 
                type="bar", orientation = 'h') %>%
      layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
             xaxis = list(title = "Area (ha)"),
             margin = list(l=0))

Tab2Plot1 =  AB_VegChange_NSR_summ %>% 
  group_by(ClassordNum, Classification, Color) %>% 
  summarize(ecosite_Area_NSR_all=sum(get(varname), na.rm = T), .groups = 'keep') %>%
  ungroup() %>%
  mutate(ecosite_Area_perc_NSR_all=round(ecosite_Area_NSR_all/sum(ecosite_Area_NSR_all)*100, 0)) %>%
  plot_ly() %>% 
  add_trace(y=~as.factor(ClassordNum), x=~ecosite_Area_NSR_all, color =~as.factor(ClassordNum), colors=~Color,  width=0.9, name=~Classification, text = ~paste0("NSR: all", "<br>", "Ecosite: ", Classification, "<br>", round(ecosite_Area_NSR_all, 0), " ha<br>", ecosite_Area_perc_NSR_all, "%"), 
            hoverinfo = 'text', showlegend=F, 
            type="bar", orientation = 'h') %>%
  layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
         xaxis = list(title = "Area (ha)"),
         margin = list(l=0))


subplot(list(Tab2Plot0, Tab2Plot1), shareX = T, titleX = T, nrows=2, heights= c(0.5, 0.5)) %>% 
  layout(annotations = list(
    list(x = 0.5 , y = 0.999, text = sprintf("<b>%s</b>", "Baseline"), font = list(size=15), showarrow = F, xref='paper', yref='paper'),
    list(x = 0.5 , y = 0.499, text = sprintf("<b>%s</b>", textPeriod), font = list(size=15), showarrow = F, xref='paper', yref='paper')))


  } else  { 
    
Tab2Plot3 <- subset(AB_VegChange_NSR_summ, NSRNAME==input$Tab2NSRSel) %>% 
  plot_ly() %>% 
  add_trace(y=~as.factor(ClassordNum), x=as.formula(paste0("~", varname0)), color =~as.factor(ClassordNum), colors=~Color, width=0.9, name=~Classification, text = ~paste0("Ecosite: ", Classification, "<br>", round(get(varname0), 0), " ha<br>", round(get(varname0perc), 0), "%"), 
                hoverinfo = 'text', showlegend=F, 
                type="bar", orientation = 'h') %>%
      layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
             xaxis = list(title = "Area (ha)"),
             margin = list(l=0))
    
Tab2Plot4 <- subset(AB_VegChange_NSR_summ, NSRNAME==input$Tab2NSRSel) %>% 
  plot_ly() %>% 
  add_trace(y=~as.factor(ClassordNum), x=as.formula(paste0("~", varname)), color =~as.factor(ClassordNum), colors=~Color, width=0.9, name=~Classification, text = ~paste0("Ecosite: ", Classification, "<br>", round(get(varname), 0), " ha<br>", round(get(varnameperc), 0), "%"), 
            hoverinfo = 'text', showlegend=F, 
            type="bar", orientation = 'h') %>%
  layout(yaxis = list(title = "", showticklabels = F, tickfont =list(size=6), tickangle = 0, autorange="reversed"),
         xaxis = list(title = "Area (ha)"),
         margin = list(l=0))

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

