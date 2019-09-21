## TODO: fix issues with local/global paths

## on init
# packrat::on("DS-minor-dashboard")

## binds remote port to the local one
## ssh stlkcmrd@r.piterdata.ninja -L 8050:127.0.0.1:8050 -N

library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)

library(stringr)
library(tidyverse)

library(here)

setwd("~/DS-minor-dashboard")

app <- Dash$new()

## TODO: as input
##### middleware

list_course = list.files("./data/processed/stepik/course_1403")

stepik_ranks = list_course %>% purrr::map(function(page) {
  str_c(getwd(), "/", "data/processed/stepik/course_1403/", page) %>% read_csv()
}) %>% plyr::rbind.fill()

# stepik_ranks = read_csv(here("DS-minor-dashboard/data/processed/stepik/course_1403/course_df_1403_page_1.csv"))

##### middleware

## a structure for a project
## modularises apps into seperate files and exports them
source(file.path("./apps/app-1.R"))
source(file.path("./apps/app-2.R"))
source(file.path("./apps/app-stepik.R"))
source(file.path("./apps/app-vle.R"))


## defines layout
app$layout(
  htmlH3("App"),
  dccLocation(id = "url", refresh = FALSE),
  # content will be rendered in this element
  htmlDiv(id = "page-content")
)

## way to define custom elements
index_page = htmlDiv(children = list(
  dccLink('Go to App 1',      href = '/apps/app-1'),
  htmlBr(),
  dccLink('Go to App 2',      href = '/apps/app-2'),
  htmlBr(),
  dccLink('Go to App Stepik', href = '/apps/app-stepik'),
  htmlBr(),
  dccLink('Go to App VLE',    href = '/apps/app-vle')
  ))




# specifies relationship between elements
app$callback(output = list(id = "page-content", property = "children"), 
             params = list(input(id = "url", property = "pathname")), 
             function(pathname) {
               if (pathname == '/apps/app-1') {
                 return(page_1_layout)
               } else if (pathname == '/apps/app-2') {
                 return(page_2_layout)
               } else if (pathname == "/apps/app-stepik") {
                 return(page_stepik_layout)
               } else if (pathname == "/apps/app-vle"){
                 return(page_vle_layout)
               } else {
                 return(index_page)
               }
             }
             )


app$run_server(showcase = TRUE, debug = TRUE, threaded = TRUE, dev_tools_ui = TRUE)
               # host = "192.168.0.232")
