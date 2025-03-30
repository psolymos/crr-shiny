# crr-shiny
> CRR: Climate-resilient Reclamation Shiny App

Scope of work:

1. Update existing app built by Ivan Bjelanovic to current standards and packages (including re-establishing broken links)
  - The updated app is in the [`app-v1`](./app-v1/) folder
  - The links point to the GitHub Pages based file server that is part of the [`docs/v1`](./docs/v1/) folder
  - Original app (v0): <https://albertaccrec.shinyapps.io/template1/>
  - New deployment (v1): <https://analythium.shinyapps.io/crr-shiny-v1/>
  - Updated Shiny app (v2): <https://analythium.shinyapps.io/crr-shiny-v2/>

2. Add results from new Alberta simulations to be provided by ApexRMS (up to 64 scenarios)
  - New results are organized inside the [`docs/v2`](./docs/v1/) folder for GitHub Pages
  - The v2 of the Shiny app ([`app-v2`](./app-v2/)) uses an easy-to-maintain logic

3. Provide commented R code and instructions for updating the app with new layers
  - The instructions are part of the [`data`](./data/) folder: [`data/instructions.pdf`](./data/instructions.pdf)

## What is in this project

- [`app-v1`](./app-v1/): Original (v1) Shiny app with updated references to static files.
- [`app-v2`](./app-v1/): V2 of the Shiny app with flexibility for adding new layers.
- [`data`](./data/): Example raster files and R scripts for data processing.
- [`docs`](./docs/): Folder with static files to served through GitHub Pages.

# License

Code: [MIT License](./LICENSE), Copyright (c) 2025 Ivan Bjelanovic, Peter Solymos

Data sets in this repo are developed by and funding for the app development provided by
[Canadian Forest Service / Natural Resources Canada / Government of Canada](https://natural-resources.canada.ca/).
