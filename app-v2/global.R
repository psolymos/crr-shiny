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

NRCan_GeoGratis_CBMT_link <- "https://maps.geogratis.gc.ca/wms/CBMT?service=wms&version=1.3.0"
fileserver_link <- "https://peter.solymos.org/crr-shiny"

area_nsr_ecosite <- read.csv("./data/area_nsr_ecosite.csv") # AB_VegChange_NSR_summ
nsr_list <- c(sort(unique(area_nsr_ecosite$NSRNAME)), "all NSRs")

ecosite_classes <- read.csv("./data/ecosite_classes.csv") # AB_VegChange_classes
files_list <- read.csv("./data/files_list.csv")
files_list$time_period <- as.character(files_list$time_period)

# functions for files

handle_paths <- function(files_list, base_url = NULL) {
  list(
    get_pred_types = function() {
      v <- na.omit(unique(files_list[,c("pred_type", "pred_type_label")]))
      structure(v$pred_type, names=v$pred_type_label)
    },
    get_time_periods = function() {
      v <- na.omit(unique(files_list[,c("time_period", "time_period_label")]))
      structure(v$time_period, names=v$time_period_label)
    },
    get_climate_models = function() {
      v <- files_list$climate_model
      v <- unique(v[!is.na(v)])
      structure(v, names=v)
    },
    get_path_for_scenario = function(pred_type, time_period, climate_model, version="v1") {
      f <- files_list$path[files_list$pred_type == pred_type &
        files_list$time_period == time_period &
        files_list$climate_model == climate_model &
        files_list$version==version]
      if (is.null(base_url)) f else file.path(base_url, f)
    },
    get_path_for_baseline = function(file_name, version="v1") {
      f <- files_list$path[files_list$pred_type == "baseline" & 
        files_list$file_name == file_name &
        files_list$version==version]
      if (is.null(base_url)) f else file.path(base_url, f)
    }
  )
}

Files <- handle_paths(files_list, fileserver_link)
# Usage:
# Files$get_path_for_baseline("BaselineUpland_prj_on")
# Files$get_path_for_scenario("Stralberg", "20112040", "CanESM2")
