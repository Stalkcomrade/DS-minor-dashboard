library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)
library(stringr)

app <- Dash$new()

## import 
## import::here(app2, .from = "./apps/app-2.R")
## import::here(app1, .from = "./apps/dash-app.R")

## defines layout
app$layout(
  htmlH3("App"),
  dccLocation(id = "url", refresh = FALSE),
  # content will be rendered in this element
  htmlDiv(id = "page-content")
)

## way to define custom elements
index_page = htmlDiv(children = list(
  dccLink('Go to App 1', href = '/apps/dash-app'),
  htmlBr(),
  dccLink('Go to App 2', href = '/apps/app-2'))
  )

page_1_layout = htmlDiv(children = list(
  htmlH3("App 1"),
  htmlImg(id = "Plot1", src = "../assets/test.png")
))


page_2_layout = htmlDiv(children = list(
  htmlH3("App 2"),
  dccInput(id = "inputID", value = "initial value", type = "text"),
  htmlDiv(id = "outputID")
))

## page 2 calback
app$callback(output = list(id = 'page-2-content', property = 'children'),
             params = list(input(id = 'page-2-dropdown', property = 'value')),
             function(value) {
               return(stringr::str_c('You have selected ', value))
             }
             )


# specifies relationship between elements
app$callback(output = list(id = "page-content", property = "children"), 
             params = list(input(id = "url", property = "pathname")), 
             function(pathname) {
               if (pathname == '/apps/dash-app') {
                 return(page_2_layout)
               } else if (pathname == '/apps/app-2') {
                 return(page_1_layout)
               } else {
                 return(index_page)
               }
             }
)

        
app$run_server(showcase = TRUE, debug = TRUE, dev_tools_hot_reload = TRUE)
