# vf = jsonlite::fromJSON("course_grades.json", simplifyVector = FALSE)
# vf[[2]] # object of arrays
# vf[[2]] %>% class()
# df = tibble(user = numeric(), score = numeric(), course = numeric(), rank = numeric())
# vf[[2]] %>% map(.f = function(.x) {
#   ## not the best practice
#    df <<- add_row(.data = df,
#           user = .x$user,
#           score = .x$score,
#           course = .x$course,
#           rank = .x$rank)
# })



## specifies relationship between elements
## app$callback(output = list(id = "page-content", property = "children"), 
##              params = list(input(id = "url", property = "pathname")), 
##              function(pathname) {
##                if (pathname == '/apps/dash-app') {
##                  return(app1$layout('This is app 1'))
##                } else if (pathname == '/apps/app2') {
##                  return(app2$layout('This is app 2'))
##                } else if (pathname == '/apps/category/app3') {
##                  return(NULL)
##                }
##              }
## )
