# CRR App v1

## Run the app locally

Install dependencies (from inside the `app-v1` folder):

```R
if (!requireNamespace("deps")) install.packages("deps")
deps::install()
```

This command will use the [`app/dependencies.json`](./app/dependencies.json)
to install dependencies.

To run the app, call `shiny::runApp("app-v1")` from R or
`R -q -e 'shiny::runApp("app-v1")'` from shell.
You can also double click the Rproj file to open the `app-v1` project in
RStudio Desktop, you can then click the 'play' icon to run the app.

## Editing the app

Use a text editor or RStudio Desktop (double click the Rproj file),
edit the files and save. Then test the app.

## Deploying the app

The app is currently deployed on Shinyapps.io:
<https://analythium.shinyapps.io/crr-shiny-v1/>

You can set up a Shinyapps.io account and deploy it there with
your RStudio Desktop by opening the `app-v1` project
(double click the Rproj file), connect your Shinyapps.io account to Rstudio,
then click the Publish button in RStudio to deploy.
