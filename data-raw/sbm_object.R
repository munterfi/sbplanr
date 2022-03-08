#!/usr/bin/env Rscript
# -----------------------------------------------------------------------------
# Name          :sbm_object.R
# Description   :Creates a 'sbm' object and saves them to 'inst'.
# Author        :Merlin Unterfinger <info@munterfinger.ch>
# Date          :2022-03-08
# Version       :0.1.0
# Usage         :./sbm_object.R
# Notes         :Load from package examples using:
#                m <- sb_import(
#                  system.file("example_i1000.RData", package = "sbplanr")
#                )
# R             :4.0.0
# =============================================================================

library(sbplanr)
set.seed(1234)

# Example data
aoi <-
  sf::st_read(system.file("example.gpkg", package = "sbplanr"), layer = "aoi")

pop <-
  sf::st_read(system.file("example.gpkg", package = "sbplanr"), layer = "pop")

poi <-
  sf::st_read(system.file("example.gpkg", package = "sbplanr"), layer = "poi")[1, ]

# Create model
m <- sb_sbm(
  model_name = "example",
  aoi = aoi, pop = pop, poi = poi,
  n_sta = 15, m_seg = 500
)
m

# Iterate
m <- sb_iterate(m, 1000)

# Export
sb_export(m, paste0(getwd(), "/inst"))

# Save graphics
sb_save_graphics(m, paste0(getwd(), "/docs"))
