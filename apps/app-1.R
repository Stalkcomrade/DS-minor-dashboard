library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)


page_1_layout = htmlDiv(children = list(
  htmlH3("App 1"),
  htmlImg(id = "Plot1", src = "../assets/test.png")
))

