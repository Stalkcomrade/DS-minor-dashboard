library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)


## setwd("~/DS-minor-dashboard")

## list_course = list.files("./data/processed/stepik/course_1403")

## stepik_ranks = list_course %>% purrr::map(function(page) {
##   str_c(getwd(), "/", "data/processed/stepik/course_1403/", page) %>% read_csv()
## }) %>% plyr::rbind.fill()


page_2_layout = htmlDiv(children = list(
  htmlH3("App 2"),
  dccInput(id = "inputID", value = "initial value", type = "text"),
  htmlDiv(id = "outputID"),
  ## should be carefull with nested lists
  dccGraph(id = "giraffe",
           figure = list(
             data = list(list(x = c(1,2,3), y = c(3,2,8), type = 'bar')),
             layout = list(title = "Let's Dance!")
           )
           ),
  dccGraph(id = "giraffe-2",
           figure = list(
             data = list(list(x = as.character(stepik_ranks$user), y = stepik_ranks$rank, type = 'bar')),
             layout = list(title = "Students' Ranks", xaxis = list(type = "category",
                                                                   title = list(text = "x axis")))
           )
           )
))
