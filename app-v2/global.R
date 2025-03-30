#global.R
#version: 0


# Libraries ----
library(shiny)
library(shinyBS)
library(shinyWidgets)
library(shinydashboard)

# need to downgrade the version of ShinydashboardPlus 
#' @ver shinydashboardPlus 0.7.5
library(shinydashboardPlus)


library(shinythemes)
library(rmarkdown)
library(shinyjs)
library(bsplus)
library(htmlwidgets)
library(htmltools)
library(shinyalert)

# library(reactlog)
library(leaflet)
library(leafem)
library(leaflet.extras)
library(leafsync)
library(sf)
library(sp)
library(geojsonio)
library(lwgeom)
library(rasterVis)
library(pals)
library(ggplot2)
library(purrr)
library(stringr)
library(httr)
library(RColorBrewer)
library(viridis)
library(dplyr, warn.conflicts = FALSE)
library(tidyr)
library(rmdformats)
library(plotly)
# library(formatR)
# library(raster)
library(terra)


minZoom = 5
maxZoom = 12

# AOSERP_soils<-read_sf("./data/AOSERP_soils.gpkg")
# AOSERP_soils_bdr<-read_sf("./data/Soil_bdr.gpkg")
# AOSERP_soils_bdr<-st_transform(AOSERP_soils_bdr, st_crs(AOSERP_soils))
# Mines2015<-read_sf("./data/Mines2015.gpkg")
# SurfaceMineableArea<-read_sf("./data/SurfaceMineableArea.gpkg")

# N1SR_simp<-read_sf("./data/NSR_simp.gpkg")
# N1SR_simp <- st_transform(N1SR_simp, 4326)
# NSR_simpl<-read_sf("./data/NSR_simpl.gpkg")

# AOSERP_soils_MinableArea_summ = read.csv("./data/AOSERP_soils_MinableArea_summ.csv")
# AOSERP_soils_Soil_summ = read.csv("./data/AOSERP_soils_Soil_summ.csv")
# AOSERP_soils_NSR_summ = read.csv("./data/AOSERP_soils_NSR_summ.csv")
# PLC30_OS_100_MinableArea_summ = read.csv("./data/PLC30_OS_100_MinableArea_summ.csv")
# PLC30_OS_100_Soil_summ = read.csv("./data/PLC30_OS_100_Soil_summ.csv")
# PLC30_OS_100_NSR_summ = read.csv("./data/PLC30_OS_100_NSR_summ.csv")
# DEP_MinableArea_summ = read.csv("./data/DEP_MinableArea_summNEW.csv")
# DEP_Soil_summ = read.csv("./data/DEP_Soil_summNEW.csv")
# DEP_NSR_summ = read.csv("./data/DEP_NSR_summNEW.csv")
# AB_VegChange_NSR_summ = read.csv("./data/AB_VegChange_NSR_summ.csv")

# DEP_classes = read.csv("./data/DEP_classes.csv")
# DEP_classes_map = read.csv("./data/DEP_classes_map.csv")
# AB_VegChange_classes = read.csv("./data/AB_VegChange_classes.csv")
# AB_VegChange_NSR_summ <- AB_VegChange_NSR_summ %>%
#   arrange(ClassordNum) 

# MinableArea_NSR_list <- levels(as.factor(DEP_MinableArea_summ$NSRNAME))
# MinableArea_NSR_list[length(MinableArea_NSR_list)+1] <- "all NSRs"
# MinableArea_NSR_list1 <- levels(as.factor(PLC30_OS_100_MinableArea_summ$NSRNAME))
# MinableArea_NSR_list1[length(MinableArea_NSR_list1)+1] <- "all NSRs"
# SoilArea_NSR_list <- levels(as.factor(PLC30_OS_100_Soil_summ$NSRNAME))
# SoilArea_NSR_list[length(SoilArea_NSR_list)+1] <- "all NSRs"
# LandcoverArea_NSR_list <- levels(as.factor(PLC30_OS_100_NSR_summ$NSRNAME))
# LandcoverArea_NSR_list[length(LandcoverArea_NSR_list)+1] <- "all NSRs"
# AB_VegChange_NSR_list <- levels(as.factor(AB_VegChange_NSR_summ$NSRNAME))
# AB_VegChange_NSR_list[length(AB_VegChange_NSR_list)+1] <- "all NSRs"


# palNSR <- colorFactor(alphabet2(18), levels  = levels(as.factor(NSR_simpl$NSRNAME)))
# Soil_texture_classes <- do.call(rbind, Map(data.frame, txt_class=c("clay", "clay loam", "sandy clay", "loam", "sand", "organic", "no data"), color=c("#003249", "#0f7173","#70C1B3", "#FFE066", "#F25F5C", "#4f0147", "#50514F")))
# LC_ABMI_classes <- do.call(rbind, Map(data.frame, LC_class=c("Open water", "Fen", "Bog", "Marsh", "Swamp", "Upland", "Wetland general"), color=c("#08306b", "#FEE391","#ADDD8E", "#8C510A", "#858F30", "#006D2C", "#F0AA45")))
# LC_ABMI_colors = c("#08306b", "#FEE391","#ADDD8E", "#8C510A", "#858F30", "#006D2C", "#F0AA45")



convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  mi
} 

# This CBMT link works
NRCan_GeoGratis_CBMT_link <- "https://maps.geogratis.gc.ca/wms/CBMT?service=wms&version=1.3.0"

fileserver_link <- "https://peter.solymos.org/crr-shiny/v1/"
