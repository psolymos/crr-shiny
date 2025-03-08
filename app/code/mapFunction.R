mapFunction<-function() {
  lng=st_coordinates(st_centroid(st_as_sf(SurfaceMineableArea)))[1]
  lat=st_coordinates(st_centroid(st_as_sf(SurfaceMineableArea)))[2]
  
  mainMap1 <-   leaflet(
    padding = 0,
    height = "80vh",
    options = leafletOptions(
      minZoom = minZoom,
      maxZoom = maxZoom,
      crs = leafletCRS(),
      worldCopyJump = F)) %>%
    setView(lng,lat,8) %>%
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
    addEasyButton(
      easyButton(id = "global_rep1",
                 icon = icon("globe", class = "fa-2x", lib = "font-awesome"),
                 title = "ROI Extent",
                 onClick = JS("function(btn, map){map.setView(L.latLng(",lat,",",lng,"),8); }")
      )
    )  %>%
    addPolygons(
      data = SurfaceMineableArea,
      fill = FALSE,
      opacity = 1,
      weight = 5,
      color = "black",
      stroke = T,
      smoothFactor = 0.5,
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
    addWMSTiles("http://maps.geogratis.gc.ca/wms/CBMT?service=wms&version=1.3.0",
                layers = "CBMT",
                group = "NRCan GeoGratis (CBMT)",
                options = WMSTileOptions(format = "image/png", transparent = T, zIndex = -1, minZoom = minZoom, maxZoom = maxZoom, opacity = 1))   %>%
    addLayersControl(
      position = c("topleft"),
      baseGroups = c("Street Map", "Stamen", "NRCan GeoGratis (CBMT)"),
      overlayGroups = c("ESRI Imagery"),
      options = layersControlOptions(collapsed = T, autoZIndex = F))
  # %>% hideGroup("ESRI Imagery")
  
  mainMap2 <- leaflet(
    padding = 0,
    height = "80vh",
    options = leafletOptions(
      minZoom = minZoom,
      maxZoom = maxZoom,
      crs = leafletCRS(),
      worldCopyJump = F)) %>%
    setView(lng,lat,8) %>%
    # addPolygons(
    #   data = Mines2015,
    #   group = "Mines",
    #   fill = FALSE,
    #   opacity = 1,
    #   weight = 5,
    #   color = "red",
    #   stroke = T,
    #   smoothFactor = 0.5,
    #   label= ~htmlEscape(paste0('Mines'))
    # ) %>%
  addPolygons(
    data = SurfaceMineableArea,
    group = "Minable area",
    fill = FALSE,
    opacity = 1,
    weight = 5,
    color = "black",
    stroke = T,
    smoothFactor = 0.5,
    label= ~htmlEscape(paste0('Surface Mineable Area'))
  ) %>%
    # addPolygons(
    #   data = AOSERP_soils,
    #   group = "AOSERP_soils",
    #   fill = FALSE,
    #   opacity = 1,
    #   weight = 5,
    #   color = "black",
    #   stroke = T,
    #   smoothFactor = 0.5,
    #   label= ~htmlEscape(paste0('Buffer (25 km) around selected community: ', AOSERP_soils$SoilGrp))
    # ) %>%
  # addPolygons(
  #   data = subset(NSR, NSRNAME %in% c("Central Mixedwood", "Lower Boreal Highlands", "Upper Boreal Highlands")),
  #   group = "NSR",
  #   fill = TRUE, 
  #   fillColor = c("red", "blue", "brown"), 
  #   fillOpacity = 0.3,
  #   stroke = T,
  #   opacity = 0.5,
  #   weight = 1,
  #   color = "white") %>%
  #   addLegend(position = "topright",
  #             colors = paste0(c("#db3312", "blue", "brown"), "; border-radius: 30%; width: 30px; height: 20px"),
  #             labels = c("Central Mixedwood", "Lower Boreal Highlands", "Upper Boreal Highlands"),
  #             opacity = 0.6,
  #             title = "Natural Subregion of Alberta") %>%
  addWMSTiles("http://maps.geogratis.gc.ca/wms/CBMT?service=wms&version=1.3.0",
              layers = "CBMT",
              group = "NRCan GeoGratis (CBMT)",
              options = WMSTileOptions(format = "image/png", transparent = T, zIndex = -1, minZoom = minZoom, maxZoom = maxZoom, opacity = 1))  
  
  
  
  
  
  m = sync(mainMap1, mainMap2, ncol=2, sync.cursor = T)
  
  return(m)
}