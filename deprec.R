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
