# CRR App v2

Install dependencies (from inside the `app-v2` folder):

```R
if (!requireNamespace("deps")) install.packages("deps")
deps::install()
```

This command will use the `dependencies.json` file to install dependencies.

To run the app, call `shiny::runApp("app-v2")` from R or
`R -q -e 'shiny::runApp("app-v2")'` from shell.

## Editing the app

Use a text editor or RStudio Desktop (double click the Rproj file),
edit the files and save. Then test the app.

## Deploying the app

The app is currently deployed on Shinyapps.io:
<https://analythium.shinyapps.io/crr-shiny-v2/>

You can set up a Shinyapps.io account and deploy it there with
your RStudio Desktop by opening the `app-v2` project
(double click the Rproj file), connect your Shinyapps.io account to Rstudio,
then click the Publish button in RStudio to deploy.
