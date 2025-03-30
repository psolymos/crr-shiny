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


library(leaflet)
library(leafem)
library(leaflet.extras)
library(leafsync)
library(sf)
library(dplyr, warn.conflicts = FALSE)
library(plotly)
library(terra)

minZoom = 5
maxZoom = 12

area_nsr_ecosite <- read.csv("./data/area_nsr_ecosite.csv") # AB_VegChange_NSR_summ
ecosite_classes <- read.csv("./data/ecosite_classes.csv") # AB_VegChange_classes

convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  mi
} 

NRCan_GeoGratis_CBMT_link <- "https://maps.geogratis.gc.ca/wms/CBMT?service=wms&version=1.3.0"

fileserver_link <- "https://peter.solymos.org/crr-shiny/v1/"
