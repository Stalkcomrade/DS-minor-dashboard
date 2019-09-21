library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)
library(dashTable)

library(zoo)

l = read_csv("./data/raw/vle/UNITED.csv")

l$time = as.POSIXct(l$timestamp / 1000.0,
                    origin='1970-01-01', tz="GMT") %>%
  zoo::as.yearmon("%m/%Y")


l$time = factor(l$time) # levels = l$time %>% unique()

# l %>% head()


l_aggr = l %>%
  group_by(type, time) %>% summarise(n_count = n())

l_spread = l_aggr %>% tidyr::spread(key = type, value = n_count,
                                    fill = 0)


# 
# p <- plotly::plot_ly(l_spread, x = ~time, y = ~input, 
#                      name = 'input', type = 'scatter', mode = 'lines',
#                      line = list(color = 'rgb(205, 12, 24)', width = 4)) %>%
#   add_trace(y = ~error, name = 'error', line = list(color = 'rgb(22, 96, 167)', width = 4)) %>%
#   add_trace(y = ~prompt, name = 'prompt', line = list(color = 'rgb(205, 12, 24)', width = 4, dash = 'dash')) %>%
#   add_trace(y = ~output, name = 'output', line = list(color = 'rgb(205, 14, 24)', width = 4, dash = 'dot')) %>%
#   layout(title = "Activities",
#          xaxis = list(title = "Months"),
#          yaxis = list (title = "Event Freq"))
# 
# p



page_vle_layout = htmlDiv(children = list(
  htmlH3("App VLE"),
  dccGraph(id = "giraffe-vle",
           figure = list(
             data = list(list(x = l_spread$time, y = l_spread$input, name = "input", type = 'scatter', mode = "lines",
                              line = list(
                                color = 'rgb(0, 0, 255)', width = 4
                                )),
                         list(x = l_spread$time, y = l_spread$output, name = "output", type = 'scatter', mode = "lines",
                              line = list(
                                color = 'rgb(137, 137, 198)', width = 4, dash = "dash"
                                )),
                         list(x = l_spread$time, y = l_spread$prompt, name = "prompt", type = 'scatter', mode = "lines",
                              line = list(
                                color = 'rgb(168, 67, 91)', width = 4, dash = "dot"
                                )),
                         list(x = l_spread$time, y = l_spread$error, name = "error", type = 'scatter', mode = "lines",
                              line = list(
                                color = 'rgb(255, 0, 0)', width = 4
                                ))),
             layout = list(title = "Activities",
                    xaxis = list(title = list(text = "Months")),
                    yaxis = list(title = list(text = "Event Freq"))
           )
           )
  )
))


# packrat::on()
# library(plotly)