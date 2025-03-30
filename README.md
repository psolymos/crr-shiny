# crr-shiny
> CRR: Climate-resilient Reclamation Shiny App

Scope of work:

1. Update existing app built by Ivan Bjelanovic to current standards and packages (including re-establishing broken links)
2. Add results from new Alberta simulations to be provided by ApexRMS (up to 64 scenarios)
3. Provide commented R code and instructions for updating the app with new layers.

## Shiny app

Original app: <https://albertaccrec.shinyapps.io/template1/>

New deployment: <https://analythium.shinyapps.io/crr-shiny/>

## What is in this project

- [`app-v1`](./app-v1/): Original (v1) Shiny app with updated references to static files.
- [`app-v2`](./app-v1/): V2 of the Shiny app with flexibility for adding new layers.
- [`data`](./data/): Example raster files and R scripts for data processing.
- [`docs`](./docs/): Folder with static files to served through GitHub Pages.

## Etc

# TODO

- find original tif layers for the ivanb.gistemp.com layers
- load these layers as cog or as tms tiles
- set up static map server for files
- adjust code

# License

[MIT License](./LICENSE), Copyright (c) 2025 Ivan Bjelanovic, Peter Solymos
