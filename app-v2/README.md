# CRR App v2

Install dependencies (from inside the `app-v2` folder):

```R
if (!requireNamespace("deps")) install.packages("deps")
deps::install()
```

This command will use the [`app/dependencies.json`](./app/dependencies.json)
to install dependencies.

To run the app, call `shiny::runApp("app-v2")` from R or
`R -q -e 'shiny::runApp("app-v2")'` from shell.
