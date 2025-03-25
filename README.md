# crr-shiny
> CRR: Climate-resilient Reclamation Shiny App

Scope of work:

1. Update existing app built by Ivan Bjelanovic to current standards and packages (including re-establishing broken links)
2. Add results from new Alberta simulations to be provided by ApexRMS (up to 64 scenarios)
3. Provide commented R code and instructions for updating the app with new layers.

# Shiny app

Original app: <https://albertaccrec.shinyapps.io/template1/>

Install dependencies (from inside the `app` folder):

```R
if (!requireNamespace("deps")) install.packages("deps")
deps::install()
```

This command will use the [`app/dependencies.json`](./app/dependencies.json)
to install dependencies.

To run the app, call `shiny::runApp("app")` from R or
`R -q -e 'shiny::runApp("app")'` from shell.

# TODO

- find original tif layers for the ivanb.gistemp.com layers
- load these layers as cog or as tms tiles
- set up static map server for files
- adjust code

# License

[MIT License](./LICENSE), Copyright (c) 2025 Ivan Bjelanovic, Peter Solymos
