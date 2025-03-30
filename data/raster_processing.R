# test versions of tiffs
library(terra)

# making crosswalk of OLD and NEW classes

es <- read.csv("app/data/AB_VegChange_classes_map.csv")
es <- es[order(es$ClassordNum),]
es <- es[,-1]
# write.csv(es, row.names=F, file="docs/ecosite_classes.csv")

# EcositeStateID: values used in new rasters
# Classification
lt <- read.csv("data/STSim_Outputs/Stralberg_EcositeVegLookup.csv")
lt <- lt[,c("Classification", "EcositeStateID")]
lt$Classification[lt$Classification==""] <- "Other Non-Fuel"
lt$Code <- es$Code[match(lt$Classification, es$Classification)]

mefa4::compare_sets(es$Classification, lt$Classification)
mefa4::compare_sets(es$Code, lt$Code)

# write.csv(lt, row.names=F, file="docs/ecosite_classes_lookup.csv")

# old files, integer versions
r1 <- rast("data/Stralberg_baseline_vegeco4top_mod_int.tif")

r1f <- r1
ct <- data.frame(value=es$Code, col=es$Color)
coltab(r1f) <- ct
plot(r1f)

r1c <- colorize(r1f, "rgb", alpha=TRUE)
plot(r1c)

# new example file
r2 <- rast("data/STSim_Outputs/sc.it1.ts100.tif")
vo <- values(r2)
vn <- vo
vn[,1] <- ifelse(is.na(vo[,1]), NA, lt$Code[match(vo[,1], lt$EcositeStateID)])
summary(vo)
summary(vn)

r3 <- r2
values(r3) <- vn

r3f <- r3
coltab(r3f) <- ct
plot(r3f)

r3c <- colorize(r3f, "rgb", alpha=TRUE)
plot(r3c)

# epsg:3857 template used before
rt <- rast("docs/scenarios/climate-driven/Stralberg_20112040_CanESM2_prj_on.tif")

TO <- rt
# TO <- "epsg:3857"

# project to web mercator
r1w <- project(r1, TO, method = "near")
r3w <- project(r3, TO, method = "near")

r1x <- project(r1f, TO, method = "near")
r3x <- project(r3f, TO, method = "near")

r1xc <- colorize(r1x, "rgb", alpha=FALSE)
r3xc <- colorize(r3x, "rgb", alpha=FALSE)

make_rgb_with_alpha <- function(x) {
  x <- colorize(x, "rgb", alpha=TRUE)
  v <- values(x)
  v[is.na(v[,4]),] <- 0
  values(x) <- v
  x
}
# r1xc <- make_rgb_with_alpha(r1x)
# r3xc <- make_rgb_with_alpha(r3x)

# save files for testing

# v1, integer, Alberta 10-TM (Forest) (EPSG:3400)
writeRaster(r1, "docs/testing/v1_3400_int.tif", overwrite=TRUE, datatype="INT1U")
# v2, integer, Alberta 10-TM (Forest) (EPSG:3400)
writeRaster(r3, "docs/testing/v2_3400_int.tif", overwrite=TRUE, datatype="INT1U")


# v1, RGB, 3857
writeRaster(r1xc, "docs/testing/v1_3857_rgb.tif", overwrite=TRUE, datatype="INT2U", gdal="COMPRESS=DEFLATE")
# v2, RGB, 3857
writeRaster(r3xc, "docs/testing/v2_3857_rgb.tif", overwrite=TRUE, datatype="INT2U", gdal="COMPRESS=DEFLATE")

system2("gdal_translate", c("-of", "COG", 
  #  "-co", "TILING_SCHEME=GoogleMapsCompatible",
  "-co", "COMPRESS=DEFLATE",
  #  "-co", "BIGTIFF=NO",
  # "-co", "OVERVIEWS=NONE",
  # "-co", "ALIGNED_LEVELS=4",
  # "-co", "COMPRESS=JPEG",
  # "-co", "RESAMPLING=NEAREST",
  # "-co", "OVERVIEW_RESAMPLING=NEAREST",
  # "-co", "WARP_RESAMPLING=NEAREST",
  # "-co", "OVERVIEWS=IGNORE_EXISTING",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "docs/testing/v1_3857_rgb.tif",
  "docs/testing/v1_3857_cog.tif"))


system2("gdalinfo","docs/testing/v1_3857_rgb.tif")
system2("gdalinfo","docs/testing/v1_3857_cog.tif")

system2("gdal_translate", c("-of", "COG", 
  #  "-co", "TILING_SCHEME=GoogleMapsCompatible",
  "-co", "COMPRESS=DEFLATE",
  #  "-co", "BIGTIFF=NO",
  # "-co", "OVERVIEWS=NONE",
  # "-co", "ALIGNED_LEVELS=4",
  # "-co", "COMPRESS=JPEG",
  # "-co", "RESAMPLING=NEAREST",
  # "-co", "OVERVIEW_RESAMPLING=NEAREST",
  # "-co", "WARP_RESAMPLING=NEAREST",
  # "-co", "OVERVIEWS=IGNORE_EXISTING",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "docs/testing/v2_3857_rgb.tif",
  "docs/testing/v2_3857_cog.tif"))


system2("gdal_translate", c("-of", "GTiff", 
  "-b", "1", "-b", "2", "-b", "3", "-b", "4", "-mask", "4", 
  "-co", "COMPRESS=DEFLATE",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "--config", "GDAL_TIFF_INTERNAL_MASK", "YES",
  "docs/testing/v1_3857_rgb.tif",
  "docs/testing/v1_3857_rgbM.tif"))

system2("gdal_translate", c("-of", "GTiff", 
  "-b", "1", "-b", "2", "-b", "3", "-b", "4", "-mask", "4", 
  "-co", "COMPRESS=DEFLATE",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "--config", "GDAL_TIFF_INTERNAL_MASK", "YES",
  "docs/testing/v2_3857_rgb.tif",
  "docs/testing/v2_3857_rgbM.tif"))

system2("gdal_translate", c("-of", "COG", 
  "-co", "COMPRESS=DEFLATE",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "docs/testing/v1_3857_rgbM.tif",
  "docs/testing/v1_3857_cogM.tif"))
system2("gdal_translate", c("-of", "COG", 
  "-co", "COMPRESS=DEFLATE",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "docs/testing/v2_3857_rgbM.tif",
  "docs/testing/v2_3857_cogM.tif"))

system2("gdalinfo","docs/testing/v1_3857_rgbM.tif")
system2("gdalinfo","docs/testing/v1_3857_cogM.tif")


leaflet() |>
addProviderTiles("OpenStreetMap.Mapnik") |>
leafem::addCOG(
  url = "https://peter.solymos.org/crr-shiny/testing/v1_3857_cog.tif",
  # url = "https://peter.solymos.org/crr-shiny/testing/v1_3857_rgb.tif",
  # url = "https://peter.solymos.org/crr-shiny/scenarios/climate-driven/Stralberg_20112040_CanESM2_prj_on.tif",
  layerId = "raster",
  opacity = 0.9,
  autozoom = TRUE)



gdal_translate -of GTiff -b 1 -b 2 -b 3 -b mask -colorinterp green,red,blue,alpha input.tif output.tif


To create a JPEG-compressed TIFF with internal mask from a RGBA dataset

gdal_translate rgba.tif withmask.tif -b 1 -b 2 -b 3 -mask 4 -co COMPRESS=JPEG \
  -co PHOTOMETRIC=YCBCR --config GDAL_TIFF_INTERNAL_MASK YES

To create a RGBA dataset from a RGB dataset with a mask

gdal_translate withmask.tif rgba.tif -b 1 -b 2 -b 3 -b mask



system2("gdal_edit", c(
  "-unsetstats", "-colorinterp_1", "red", "-colorinterp_2", "green", 
  "-colorinterp_3", "blue", "-colorinterp_4", "alpha", 
  "docs/testing/v1_3857_rgb.tif"))
system2("gdal_edit", c(
  "-unsetstats", "-colorinterp_1", "red", "-colorinterp_2", "green", 
  "-colorinterp_3", "blue", "-colorinterp_4", "alpha", 
  "docs/testing/v2_3857_rgb.tif"))

# https://gdal.org/en/stable/drivers/raster/cog.html
system2("gdal_translate", c("-of", "COG", 
  "-co", "COMPRESS=DEFLATE",
  "-co", "RESAMPLING=NEAREST",
  "-co", "OVERVIEW_RESAMPLING=NEAREST",
  "-co", "WARP_RESAMPLING=NEAREST",
  "-co", "OVERVIEWS=IGNORE_EXISTING",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "docs/testing/v1_3857_rgb.tif",
  "docs/testing/v1_3857_cog.tif"))

system2("gdal_translate", c("-of", "COG", 
  "-co", "COMPRESS=DEFLATE",
  "-co", "RESAMPLING=NEAREST",
  "-co", "OVERVIEW_RESAMPLING=NEAREST",
  "-co", "WARP_RESAMPLING=NEAREST",
  "-co", "OVERVIEWS=IGNORE_EXISTING",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "docs/testing/v2_3857_rgb.tif",
  "docs/testing/v2_3857_cog.tif"))

# no overviews...
system2("gdal_translate", c("-of", "COG", 
  "-co", "COMPRESS=DEFLATE",
  "-co", "RESAMPLING=NEAREST",
  "-co", "OVERVIEW_RESAMPLING=NEAREST",
  "-co", "WARP_RESAMPLING=NEAREST",
  "-co", "OVERVIEWS=IGNORE_EXISTING",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "-co", "OVERVIEWS=NONE",
  "docs/testing/v1_3857_rgb.tif",
  "docs/testing/v1_3857_cog2.tif"))

system2("gdal_translate", c("-of", "COG", 
  "-co", "COMPRESS=DEFLATE",
  "-co", "RESAMPLING=NEAREST",
  "-co", "OVERVIEW_RESAMPLING=NEAREST",
  "-co", "WARP_RESAMPLING=NEAREST",
  "-co", "OVERVIEWS=IGNORE_EXISTING",
  "-co", "PREDICTOR=2",
  "-co", "STATISTICS=NO",
  "-co", "OVERVIEWS=NONE",
  "docs/testing/v2_3857_rgb.tif",
  "docs/testing/v2_3857_cog2.tif"))

system2("gdalinfo", c("--format", "COG", "docs/scenarios/climate-driven/Stralberg_20112040_CanESM2_prj_on.tif"))

system2("gdalinfo", "docs/scenarios/climate-driven/Stralberg_20112040_CanESM2_prj_on.tif")
system2("gdalinfo", "docs/testing/v1_3857_rgb.tif")
system2("gdalinfo", "docs/testing/v1_3857_rgbM.tif")
system2("gdalinfo", "docs/testing/v1_3857_cog.tif")
system2("gdalinfo", "docs/testing/v1_3857_cog2.tif")




# datatype:  values accepted are "INT1U", "INT2U", "INT2S", "INT4U", "INT4S", "FLT4S", "FLT8S". With GDAL >= 3.5 you can also use "INT8U" and "INT8S". And with GDAL >= 3.7 you can use also use "INT1S". 
# The first three letters indicate whether the datatype is an integer (whole numbers) of a real number ("float", decimal numbers), the fourth character indicates the number of bytes used for each number. 
# Higher values allow for storing larger numbers and/or more precision; but create larger files. 
# The  "S" or "U" indicate whether the values are signed (both negative and positive) or unsigned (zero and positive values only). 
# INT1U : 0-254 (2^8-1, minus one for NA storage)
# INT2U : 0-65,534 (2^16-1, minus one for NA storage)
# INT4U : 0-4,294,967,294 (2^32-1, minus one for NA storage)
# we need INT1U for the raw data files - we can load and summarize on the fly


# create new csv with new Other category, inherit colors and add something for Other
# write a function that would replace the values according to the categories
# write a function that saves the smallest file
# write a function that colorizes the integer values to RGB
# write a function that saves the RGB version

# test speed for COG vs Geotiff vs Raster in leaflet (speed, colors)

library(leaflet)

f_int <- "https://peter.solymos.org/crr-shiny/testing/v1_3400_int.tif"
f_rgb <- "https://peter.solymos.org/crr-shiny/testing/v1_3857_rgb.tif"
# f_int <- "https://peter.solymos.org/crr-shiny/testing/v2_3400_int.tif"
# f_rgb <- "https://peter.solymos.org/crr-shiny/testing/v3_3857_rgb.tif"

r_int <- rast(f_int)
coltab(r_int) <- ct
r_int2 <- project(r_int, "epsg:3857", method = "near")
r_rgb <- colorize(r_int, "rgb", alpha=TRUE)
r_rgb2 <- colorize(r_int2, "rgb", alpha=TRUE)

NRCan_GeoGratis_CBMT_link <- "http://maps.geogratis.gc.ca/wms/CBMT?service=wms&version=1.3.0"

leaflet() |>
  addWMSTiles(NRCan_GeoGratis_CBMT_link,
    layers = "CBMT",
    attribution="NRCan GeoGratis",
    group = "NRCan GeoGratis (CBMT)",
    options = WMSTileOptions(
      format = "image/png", transparent = T, zIndex = -1, opacity = 1)) |>
  # leafem::addCOG(
  leafem::addGeotiff(
      # url = "https://peter.solymos.org/crr-shiny/testing/v1_3857_cog.tif",
      url = "https://peter.solymos.org/crr-shiny/testing/v1_3857_rgb.tif",
      # url = "https://peter.solymos.org/crr-shiny/scenarios/climate-driven/Stralberg_20112040_CanESM2_prj_on.tif",
      rgb = TRUE,
      attribution="CFS NRCAN",
      layerId = "geotiff",
      group = "GEOTIFF")

leaflet() |>
  addWMSTiles(NRCan_GeoGratis_CBMT_link,
    layers = "CBMT",
    attribution="NRCan GeoGratis",
    group = "NRCan GeoGratis (CBMT)",
    options = WMSTileOptions(
      format = "image/png", transparent = T, zIndex = -1, opacity = 1)) |>
  leaflet::addRasterImage(r_int)

leaflet() |>
  addWMSTiles(NRCan_GeoGratis_CBMT_link,
    layers = "CBMT",
    attribution="NRCan GeoGratis",
    group = "NRCan GeoGratis (CBMT)",
    options = WMSTileOptions(
      format = "image/png", transparent = T, zIndex = -1, opacity = 1)) |>
  leaflet::addRasterImage(r_rgb)
leaflet() |>
  addWMSTiles(NRCan_GeoGratis_CBMT_link,
    layers = "CBMT",
    attribution="NRCan GeoGratis",
    group = "NRCan GeoGratis (CBMT)",
    options = WMSTileOptions(
      format = "image/png", transparent = T, zIndex = -1, opacity = 1)) |>
  leaflet::addRasterImage(r_rgb2, project=FALSE)


leaflet() |>
  addWMSTiles(NRCan_GeoGratis_CBMT_link,
    layers = "CBMT",
    attribution="NRCan GeoGratis",
    group = "NRCan GeoGratis (CBMT)",
    options = WMSTileOptions(
      format = "image/png", transparent = T, zIndex = -1, opacity = 1)) |>
  # leafem::addGeotiff(
  #     file = "docs/scenarios/climate-driven/Stralberg_20112040_CanESM2_prj_on.tif")
  leafem::addGeotiff(
      file = "docs/testing/v2_3857_rgb.tif", rgb=TRUE)



system2("gdalinfo", "docs/scenarios/climate-driven/Stralberg_20112040_CanESM2_prj_on.tif")
system2("gdalinfo", "docs/testing/v1_3857_rgb5.tif")




### NOT WORKING
Data axis to CRS axis mapping: 1,2
Origin = (-13462700.917811524122953,8453323.832114212214947)
Pixel Size = (1222.992452562820063,-1222.992452562820063)
Metadata:
  AREA_OR_POINT=Area
Image Structure Metadata:
  LAYOUT=COG
  COMPRESSION=DEFLATE
  INTERLEAVE=PIXEL
  PREDICTOR=2
Tiling Scheme:
  NAME=GoogleMapsCompatible
  ZOOM_LEVEL=7
Corner Coordinates:
Upper Left  (-13462700.918, 8453323.832) (120d56'15.00"W, 60d14'23.32"N)
Lower Left  (-13462700.918, 5948635.289) (120d56'15.00"W, 47d 2'24.66"N)
Upper Right (-11897270.579, 8453323.832) (106d52'30.00"W, 60d14'23.32"N)
Lower Right (-11897270.579, 5948635.289) (106d52'30.00"W, 47d 2'24.66"N)
Center      (-12679985.748, 7200979.561) (113d54'22.50"W, 54d 9'44.76"N)
Band 1 Block=256x256 Type=Byte, ColorInterp=Red
  Mask Flags: PER_DATASET ALPHA 
Band 2 Block=256x256 Type=Byte, ColorInterp=Green
  Mask Flags: PER_DATASET ALPHA 
Band 3 Block=256x256 Type=Byte, ColorInterp=Blue
  Mask Flags: PER_DATASET ALPHA 
Band 4 Block=256x256 Type=Byte, ColorInterp=Alpha


### WORKING
Data axis to CRS axis mapping: 1,2
Origin = (-13463565.828299999237061,8425636.536499999463558)
Pixel Size = (861.000000000000000,-862.999999999999659)
Metadata:
  AREA_OR_POINT=Area
Image Structure Metadata:
  COMPRESSION=DEFLATE
  INTERLEAVE=PIXEL
  PREDICTOR=2
Corner Coordinates:
Upper Left  (-13463565.828, 8425636.536) (120d56'42.97"W, 60d 6'58.04"N)
Lower Left  (-13463565.828, 6252602.537) (120d56'42.97"W, 48d52' 7.12"N)
Upper Right (-12067884.828, 8425636.536) (108d24'27.55"W, 60d 6'58.04"N)
Lower Right (-12067884.828, 6252602.537) (108d24'27.55"W, 48d52' 7.12"N)
Center      (-12765725.328, 7339119.536) (114d40'35.26"W, 54d52'57.46"N)
Band 1 Block=1621x1 Type=Byte, ColorInterp=Red
  Mask Flags: PER_DATASET ALPHA 
Band 2 Block=1621x1 Type=Byte, ColorInterp=Green
  Mask Flags: PER_DATASET ALPHA 
Band 3 Block=1621x1 Type=Byte, ColorInterp=Blue
  Mask Flags: PER_DATASET ALPHA 
Band 4 Block=1621x1 Type=Byte, ColorInterp=Alpha