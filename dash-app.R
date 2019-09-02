library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)


app <- Dash$new()

## import 
import::here(app2, .from = "./apps/app-2.R")
import::here(app1, .from = "./apps/dash-app.R")

## defines layout
app$layout(
  dccLocation(id = "url", refresh = FALSE),
  # content will be rendered in this element
  htmlDiv(id = "page-content")
)

## specifies relationship between elements
app$callback(output = list(id = "page-content", property = "children"), 
             params = list(input(id = "url", property = "pathname")), 
             function(pathname) {
               if (pathname == '/apps/dash-app') {
                 return(app1$layout('This is app 1'))
               } else if (pathname == '/apps/app2') {
                 return(app2$layout('This is app 2'))
               } else if (pathname == '/apps/category/app3') {
                 return(NULL)
               }
             }
)
        
app$run_server(showcase = TRUE, debug = TRUE)
