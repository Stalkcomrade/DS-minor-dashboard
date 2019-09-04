## TODO: install.packages(import)
# install.packages('devtools')
# library(devtools)
#install_github("plotly/dashR") # installs dashHtmlComponents, dashCoreComponents, and dashTable
# load deps

library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)


app1 <- Dash$new()
## defines layout

app1$layout(
  htmlH3("App1"),
  dccInput(id = "inputID", value = "initial value", type = "text"),
  htmlDiv(id = "outputID"),
  htmlImg(id = "Plot1", src = "./assets/test.png")
)

## specifies relationship between elements
app1$callback(output = list(id = "outputID", property = "children"), 
             params = list(input(id = "inputID", property = "value"),
                           state(id = "inputID", property = "type")), 
             function(x, y) {
               sprintf("You've entered: '%s' into a '%s' input control", x, y)
             }
             )

## app1$run_server(showcase = TRUE)


