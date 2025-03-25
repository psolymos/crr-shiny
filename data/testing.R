NRCan_GeoGratis_CBMT_link <- "http://maps.geogratis.gc.ca/wms/CBMT?service=wms&version=1.3.0"
# NRCan_GeoGratis_CBMT_link <- "https://maps-cartes.services.geo.ca:443/server2_serveur2/services/BaseMaps/CBMT3978/MapServer/WmsServer"

geoserver_link <- "http://ivanb.gistemp.com/geoserver/data/wms/service=WMS&version=1.1.0&request=GetMap&layers=data%3APLC30_OS_100_col&bbox=-1.34585454766E7%2C6260451.0369%2C-1.21423165921E7%2C8420920.5171&width=467&height=768&srs=EPSG%3A3857"

myCustomJSFunc = htmlwidgets::JS(
  "
    pixelValuesToColorFn = (raster, colorOptions) => {
    // helpers from https://stackoverflow.com/questions/5623838/rgb-to-hex-and-hex-to-rgb
      function componentToHex(c) {
        var hex = c.toString(16);
        return hex.length == 1 ? '0' + hex : hex;
      }
      
      function rgbToHex(r, g, b) {
        return '#' + componentToHex(r) + componentToHex(g) + componentToHex(b);
      }

      var pixelFunc = values => {
        if (isNaN(values[0])) return colorOptions.naColor;
        return rgbToHex(values[3], values[2], values[1]);
      };
      return pixelFunc;
    };
  "
)


leaflet(
  padding = 0,
  height = "90vh",
  options = leafletOptions(
    attributionControl=FALSE,
    minZoom = minZoom,
    maxZoom = maxZoom,
    crs = leafletCRS(),
    worldCopyJump = F)) %>%
  # fitBounds(
  #   extent(SurfaceMineableArea)[1], extent(SurfaceMineableArea)[3], 
  #   extent(SurfaceMineableArea)[2], extent(SurfaceMineableArea)[4]) %>%
  addWMSTiles(NRCan_GeoGratis_CBMT_link,
              layers = "CBMT",
              attribution="NRCan GeoGratis",
              group = "NRCan GeoGratis (CBMT)",
              options = WMSTileOptions(
                format = "image/png", transparent = T, zIndex = -1, 
                minZoom = minZoom, maxZoom = maxZoom, opacity = 1)) %>%
  # addWMSTiles(baseUrl = geoserver_link,
  #             layers= c("DEP_baselayer_on"),
  #             attribution="CFS NRCAN",
  #             options = WMSTileOptions(
  #               opacity = 1,transparent = T,format="image/png"),
  #             group = "Derived Ecosite Phase") %>%
  leafem::addGeotiff(
      # file = raster_file,
      url = raster_url,
      attribution="CFS NRCAN",
      layerId = "geotiff",
      group = "GEOTIFF",
      rgb = TRUE,
      bands = NULL,
      # pixelValuesToColorFn = myCustomJSFunc,
      colorOptions = colorOptions(na.color = "transparent")
  ) |>
  addRasterImage(
      x = raster("./data/DEP_PROJleaflet.tif"),
      colors = colorFactor(DEP_classes_map$Color, domain = DEP_classes_map$RasterNum, levels = NULL, ordered = FALSE, na.color = "#00000000", alpha = FALSE, reverse = FALSE),
      opacity = 1,
      maxBytes=2000*1024*1024,
      project=F,
      group = "Derived Ecosite Phase (Old)") %>%
  addWMSTiles(baseUrl = geoserver_link,
      layers= c("PLC30_OS_100_col"),
      attribution="CFS NRCAN",
      group = "ABMI predictive landcover (3.0)",
      options = WMSTileOptions(opacity = 1, format = "image/png", transparent = TRUE)) %>%
  addLayersControl(overlayGroups = c("ABMI predictive landcover (3.0)", 
    "Derived Ecosite Phase", "Derived Ecosite Phase (Old)", "GEOTIFF"), 
      position = c("topright"),
      options = layersControlOptions(collapsed = F)) %>% 
  hideGroup("ABMI predictive landcover (3.0)")  %>% 
  hideGroup("Derived Ecosite Phase (Old)") 

r <- terra::rast("data/FRUs-500m.tif")


# these are the layers being loaded from ivanb.gistemp.com which is down

# data
# DEP_baselayer_on / ABMI predictive landcover (3.0) / DEP=derived ecosite phase
# PLC30_OS_100_col / ABMI predictive landcover (3.0)
# PLC30_OS_100_prj_on / Mask lowland (ABMI landcover)

# data/AB_VegChange/BaselineVeg
# c(paste0(input$predType,"_", "20112040","_",input$climMod,"_prj_on")) / 2011-2040 Period
# c(paste0(input$predType,"_", "20412070","_",input$climMod,"_prj_on")) / 2041-2070 Period
# c(paste0(input$predType,"_", "20712100","_",input$climMod,"_prj_on")) / 2071-2100 Period

# data/AB_VegChange/BaselineVeg
# BaselineUpland_prj_on / Mask lowland (2018 study)
# Stralberg_baseline_vegeco4top_mod_prj_on / Baseline ecosite (2018)

# predType
# "Fire-mediated, constrained" ="ab_veg_fm_c",
# "Fire-mediated, unconstrained" ="ab_veg_fm_uc",
# "Climate Driven" ="Stralberg"

# climMod
# "CanESM2"= "CanESM2",
# "CSIRO"= "CSIRO",
# "HadGEM2"= "HadGEM2"

minZoom = 5
maxZoom = 12

DEP_classes_map = read.csv("./app/data/DEP_classes_map.csv")

raster_file = "app/data/AB_VegChange/BaselineVeg/BaselineUpland_prj.tif"
# raster_url <- "https://peter.solymos.org/testapi/crr-layers/BaselineUpland_prj_on.tif"
raster_url <- "https://peter.solymos.org/testapi/crr-layers/Stralberg_20412070_HadGEM2_prj_on.tif"



  addWMSTiles(baseUrl = geoserver_link,
      layers= c("PLC30_OS_100_col"),
      attribution="CFS NRCAN",
      group = "ABMI predictive landcover (3.0)",
      options = WMSTileOptions(opacity = 1, format = "image/png", transparent = TRUE)) %>%
  leafem::addGeotiff(
      file = raster_file
      # url = raster_url,
      attribution="CFS NRCAN",
      group = "ABMI predictive landcover (3.0)",
      rgb = FALSE,
      bands = 1
  ) |>


raster_url <- "https://peter.solymos.org/crr-shiny/scenarios/climate-driven/Stralberg_20412070_HadGEM2_prj_on.tif"

m |>
  leafem::addGeotiff(
      # file = raster_file,
      url = raster_url,
      project = FALSE,
      opacity = opacity,
      autozoom = FALSE,
      layerId = "raster",
      rgb = rgb,
      bands = 1:3,
      options = leaflet::tileOptions(
        maxNativeZoom = 20,
        zIndex = 400
      ),
      colorOptions = leafem::colorOptions(
          palette = get_pal(50, type), 
          domain = c(0, 255),
          na.color = "transparent")) |>
    addLegend(pal = colorNumeric(palette=get_pal(50, type), domain = c(0, 255)), 
        values = c(0, 255),
        opacity = opacity,
        title = "Title")

# leaflet(options = leafletOptions(maxZoom = 40)) |>
# addProviderTiles("Esri.WorldImagery", group = "ESRI",
#   options = providerTileOptions(maxNativeZoom=20,maxZoom=40)) |>
# leafem::addCOG(
#   url = paste0(app_url(), "/", file_name),
#   layerId = "raster",
#   opacity = 0.7,
#   autozoom = TRUE)


r <- terra::rast(raster_url)
r <- terra::rast(raster_file)


raster_url <- "https://peter.solymos.org/crr-shiny/scenarios/climate-driven/Stralberg_20412070_HadGEM2_prj_on.tif"
raster_file <- "/Users/Peter/git/github.com/psolymos/crr-shiny/docs/scenarios/climate-driven/Stralberg_20412070_HadGEM2_prj_on.tif"

leaflet(
  padding = 0,
  height = "90vh",
  options = leafletOptions(
    attributionControl=FALSE,
    minZoom = minZoom,
    maxZoom = maxZoom,
    crs = leafletCRS(),
    worldCopyJump = F)) %>%
  addWMSTiles(NRCan_GeoGratis_CBMT_link,
              layers = "CBMT",
              attribution="NRCan GeoGratis",
              group = "NRCan GeoGratis (CBMT)",
              options = WMSTileOptions(
                format = "image/png", transparent = T, zIndex = -1, 
                minZoom = minZoom, maxZoom = maxZoom, opacity = 1)) %>%
    leafem::addCOG(
        url = raster_url,
        rgb = TRUE,
        attribution="CFS NRCAN",
        layerId = "geotiff",
        group = "GEOTIFF")
  # leafem::addGeotiff(
  #     # file = raster_file,
  #     url = raster_url,
  #     attribution="CFS NRCAN",
  #     layerId = "geotiff",
  #     group = "GEOTIFF",
  #     rgb = TRUE,
  #     bands = NULL#,
  #     # pixelValuesToColorFn = myCustomJSFunc,
  #     # colorOptions = colorOptions(na.color = "transparent")
  # )


system2("gdalinfo", raster_file)

