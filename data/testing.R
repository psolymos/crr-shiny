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

# test versions of tiffs
library(terra)

f1 <- "data/Stralberg_baseline_vegeco4top_mod.tif"
f2 <- "data/Stralberg_baseline_vegeco4top_mod_int.tif"
f3 <- "data/Stralberg_baseline_vegeco4top_mod_prj_on.tif"

r1 <- rast(f1)
r2 <- rast(f2)
r3 <- rast(f3)

colr <- read.csv("app/data/AB_VegChange_classes_map.csv")
colr <- colr[order(colr$ClassordNum),]

system2("gdalinfo", f1)
# Driver: GTiff/GeoTIFF
# Files: data/Stralberg_baseline_vegeco4top_mod.tif
# Size is 1390, 2468
# Coordinate System is:
# PROJCRS["unknown",
#     BASEGEOGCRS["unknown",
#         DATUM["North American Datum 1983",
#             ELLIPSOID["GRS 1980",6378137,298.257222101,
# ...
#         AXIS["northing",north,
#             ORDER[2],
#             LENGTHUNIT["metre",1,
#                 ID["EPSG",9001]]]]
# Data axis to CRS axis mapping: 1,2
# Origin = (170616.182190249994164,6659532.431094099767506)
# Pixel Size = (500.000000000000000,-500.000000000000000)
# Metadata:
#   AREA_OR_POINT=Area
# Image Structure Metadata:
#   COMPRESSION=LZW
#   INTERLEAVE=BAND
# Corner Coordinates:
# Upper Left  (  170616.182, 6659532.431) (120d54'23.75"W, 59d57'52.75"N)
# Lower Left  (  170616.182, 5425532.431) (119d29'52.97"W, 48d54'52.03"N)
# Upper Right (  865616.182, 6659532.431) (108d26'54.17"W, 59d56' 2.70"N)
# Lower Right (  865616.182, 5425532.431) (110d 0'32.51"W, 48d53'38.86"N)
# Center      (  518116.182, 6042532.431) (114d43'11.27"W, 54d33' 6.39"N)
# Band 1 Block=1390x1 Type=Float32, ColorInterp=Gray
#   Min=1.000 Max=50.000 
#   Minimum=1.000, Maximum=50.000, Mean=-9999.000, StdDev=-9999.000
#   NoData Value=-3.4e+38
#   Metadata:
#     STATISTICS_MINIMUM=1
#     STATISTICS_MAXIMUM=50
#     STATISTICS_MEAN=-9999
#     STATISTICS_STDDEV=-9999

system2("gdalinfo", f2)
# Driver: GTiff/GeoTIFF
# Files: data/Stralberg_baseline_vegeco4top_mod_int.tif
# Size is 1390, 2468
# Coordinate System is:
# PROJCRS["unknown",
#     BASEGEOGCRS["unknown",
#         DATUM["North American Datum 1983",
#             ELLIPSOID["GRS 1980",6378137,298.257222101,
#                 LENGTHUNIT["metre",1]],
#             ID["EPSG",6269]],
#         PRIMEM["Greenwich",0,
#             ANGLEUNIT["degree",0.0174532925199433,
#                 ID["EPSG",9122]]]],
# ...
#     CS[Cartesian,2],
#         AXIS["easting",east,
#             ORDER[1],
#             LENGTHUNIT["metre",1,
#                 ID["EPSG",9001]]],
#         AXIS["northing",north,
#             ORDER[2],
#             LENGTHUNIT["metre",1,
#                 ID["EPSG",9001]]]]
# Data axis to CRS axis mapping: 1,2
# Origin = (170616.182190249994164,6659532.431094099767506)
# Pixel Size = (500.000000000000000,-500.000000000000000)
# Metadata:
#   AREA_OR_POINT=Area
# Image Structure Metadata:
#   COMPRESSION=LZW
#   INTERLEAVE=BAND
# Corner Coordinates:
# Upper Left  (  170616.182, 6659532.431) (120d54'23.75"W, 59d57'52.75"N)
# Lower Left  (  170616.182, 5425532.431) (119d29'52.97"W, 48d54'52.03"N)
# Upper Right (  865616.182, 6659532.431) (108d26'54.17"W, 59d56' 2.70"N)
# Lower Right (  865616.182, 5425532.431) (110d 0'32.51"W, 48d53'38.86"N)
# Center      (  518116.182, 6042532.431) (114d43'11.27"W, 54d33' 6.39"N)
# Band 1 Block=1390x2 Type=Int16, ColorInterp=Gray
#   Min=1.000 Max=50.000 
#   Minimum=1.000, Maximum=50.000, Mean=-9999.000, StdDev=-9999.000
#   NoData Value=-32768
#   Metadata:
#     STATISTICS_MINIMUM=1
#     STATISTICS_MAXIMUM=50
#     STATISTICS_MEAN=-9999
#     STATISTICS_STDDEV=-9999

system2("gdalinfo", f3)
# Driver: GTiff/GeoTIFF
# Files: data/Stralberg_baseline_vegeco4top_mod_prj_on.tif
# Size is 1621, 2518
# Coordinate System is:
# PROJCRS["WGS 84 / Pseudo-Mercator",
#     BASEGEOGCRS["WGS 84",
#         ENSEMBLE["World Geodetic System 1984 ensemble",
#             MEMBER["World Geodetic System 1984 (Transit)"],
# ...
#     CS[Cartesian,2],
#         AXIS["easting (X)",east,
#             ORDER[1],
#             LENGTHUNIT["metre",1]],
#         AXIS["northing (Y)",north,
#             ORDER[2],
#             LENGTHUNIT["metre",1]],
#     USAGE[
#         SCOPE["Web mapping and visualisation."],
#         AREA["World between 85.06°S and 85.06°N."],
#         BBOX[-85.06,-180,85.06,180]],
#     ID["EPSG",3857]]
# Data axis to CRS axis mapping: 1,2
# Origin = (-13463565.828299999237061,8425636.536499999463558)
# Pixel Size = (861.000000000000000,-862.999999999999659)
# Metadata:
#   AREA_OR_POINT=Area
# Image Structure Metadata:
#   COMPRESSION=DEFLATE
#   INTERLEAVE=PIXEL
#   PREDICTOR=2
# Corner Coordinates:
# Upper Left  (-13463565.828, 8425636.536) (120d56'42.97"W, 60d 6'58.04"N)
# Lower Left  (-13463565.828, 6252602.537) (120d56'42.97"W, 48d52' 7.12"N)
# Upper Right (-12067884.828, 8425636.536) (108d24'27.55"W, 60d 6'58.04"N)
# Lower Right (-12067884.828, 6252602.537) (108d24'27.55"W, 48d52' 7.12"N)
# Center      (-12765725.328, 7339119.536) (114d40'35.26"W, 54d52'57.46"N)
# Band 1 Block=1621x1 Type=Byte, ColorInterp=Red
#   Mask Flags: PER_DATASET ALPHA 
# Band 2 Block=1621x1 Type=Byte, ColorInterp=Green
#   Mask Flags: PER_DATASET ALPHA 
# Band 3 Block=1621x1 Type=Byte, ColorInterp=Blue
#   Mask Flags: PER_DATASET ALPHA 
# Band 4 Block=1621x1 Type=Byte, ColorInterp=Alpha

coltb <- data.frame(value=colr$Code, col=colr$Color)

coltab(r1) <- coltb
plot(r1)



leaflet() |>
  # addProviderTiles("Stamen.Watercolor") |>
  addRasterImage(r2, method = "ngb")

col2rgb(coltb$col, alpha=TRUE) 

r4 <- colorize(r1, "rgb", alpha=TRUE)

# STSim

f1 <- "data/STSim_Outputs/sc.it1.ts100.tif"
r1 <- rast(f1)
summary(values(r1))
lt <- read.csv("data/STSim_Outputs/Stralberg_EcositeVegLookup.csv")

v <- na.omit(sort(unique(values(r1)[,1])))
mefa4::compare_sets(v, lt$EcositeStateID)
lt[lt$EcositeStateID %in% setdiff(lt$EcositeStateID, v),]

mefa4::compare_sets(colr$Classification, lt$Classification)
setdiff(lt$Classification, colr$Classification)

system2("gdalinfo", f1)
# seems to be epsg:3400 <https://epsg.io/3400>
# need web mercator for leaflet:
# EPSG:4326 is in degrees - 3D sphere
# EPSG:3857 is in metres - 2D projection
# EPSG: 4326 uses a coordinate system on the surface of a sphere or ellipsoid of reference.
# EPSG: 3857 uses a coordinate system PROJECTED from the surface of the sphere or ellipsoid to a flat surface.

# need a mask layer b/c project() does not have nearest neighbor interpolation
r0 <- r1*0 + 1
mask <- project(r0, "epsg:3857")

# map the values to expected categories
# project to web mercator using NN
# save as INT1U 1-band TIF
r1x <- project(r1, "epsg:3857", method = "near")
writeRaster(r1x, "data/STSim_Outputs/sc.it1.ts100_INT1U.tif", overwrite=TRUE, datatype="INT1U")


# datatype:  values accepted are "INT1U", "INT2U", "INT2S", "INT4U", "INT4S", "FLT4S", "FLT8S". With GDAL >= 3.5 you can also use "INT8U" and "INT8S". And with GDAL >= 3.7 you can use also use "INT1S". 
# The first three letters indicate whether the datatype is an integer (whole numbers) of a real number ("float", decimal numbers), the fourth charac
# ter indicates the number of bytes used for each number. Higher values allow for storing larger numbers and/or more precision; but create larger files. 
# The  "S" or "U" indicate whether the values are signed (both negative and positive) or unsigned (zero and positive values only). 
# INT1U : 0-254 (2^8-1, minus one for NA storage)
# INT2U : 0-65,534 (2^16-1, minus one for NA storage)
# INT4U : 0-4,294,967,294 (2^32-1, minus one for NA storage)
# we need INT1U

# create new csv with new Other category, inherit colors and add something for Other
# write a function that would replace the values according to the categories
# write a function that saves the smallest file
# write a function that colorizes the integer values to RGB
# write a function that saves the RGB version

# test speed for COG vs Geotiff vs Raster in leaflet (speed, colors)

# ??? rasterToPolygon
p <- as.polygons(r2, aggregate = TRUE)
