
library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)


app2 <- Dash$new()

## defines layout
app2$layout(
  htmlH3("App2"),
  dccInput(id = "inputID", value = "initial value", type = "text"),
  htmlDiv(id = "outputID"),
)

## specifies relationship between elements
app2$callback(output = list(id = "outputID", property = "children"), 
              params = list(input(id = "inputID", property = "value"),
                            state(id = "inputID", property = "type")), 
              function(x, y) {
                sprintf("You've entered: '%s' into a '%s' input control", x, y)
              }
             )

## app2$run_server(showcase = TRUE)
