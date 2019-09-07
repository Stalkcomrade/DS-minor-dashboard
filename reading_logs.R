library(magrittr)
library(dplyr)
library(lubridate)
library(stringr)
library(readr)

library(googlesheets)

library(rjson)
library(RJSONIO)

library(doMC)
library(foreach)

path = "/srv/store/principal/audit/r-console/"
# data <- fromJSON(sprintf("[%s]", paste(readLines("~/share/research/minor/2017_logs/addmitriev_1.jsonl"),collapse=",")))


line = RJSONIO::fromJSON(d)

lapply(d, function(logline) {
  line = RJSONIO::fromJSON(logline)
  return(data.frame(username=line$username))
})



path <- "WHERE/YOUR/JSON/IS/SAVED"
c <- file("~/share/research/minor/2017_logs/addmitriev_1.jsonl", "r")

d = readLines(c, -1L) %>% enc2utf8()
# json <- lapply(X=d, fromJSON)
# d = readLines("~/share/research/minor/2017_logs/addmitriev_1.jsonl", -1L) %>% enc2utf8()

j = parselog(d)
j = RJSONIO::fromJSON(d)

parselog = function(log){
  data = lapply(log, function(logline){
    line = RJSONIO::fromJSON(logline)
    return(data.frame(timestamp = line$timestamp, 
                      data = line$data,
                      type = line$type, 
                      username=line$username,
                      pid=line$pid))
  })
  
  activity = plyr::rbind.fill(data)
  activity$time = as.POSIXct(round(activity$timestamp/1000), origin="1970-01-01")
  
  
  activity$weekday = ordered(weekdays(activity$time), levels=c("Понедельник",
                                                               "Вторник",
                                                               "Среда",
                                                               "Четверг",
                                                               "Пятница",
                                                               "Суббота",
                                                               "Воскресенье"
                                                              ))
  
  activity
}



list.names = list.files(path = path)
list.names = str_replace_all(list.names,".jsonl","")



# # Choosing particular student
# list.names = list.names[list.names == "addmitriev_1"]
# d = readLines("~/share/research/minor/2017_logs/addmitriev_1.jsonl") %>% enc2utf8()

# # clean <- str_replace_all(d,'\\', "")
# d = gsub("\\", "", d, fixed=TRUE)

# j = d %>% parselog()
# j = d %>% fromJSON()
# readLines(str_c(path, "pozdniakovs", ".jsonl")) %>% enc2utf8() %>% parselog()  %>%  head()


# registerDoMC(8)

# l = foreach(person = list.names, .combine='rbind', .inorder=FALSE) %dopar% {
#   tryCatch({
#     readLines(str_c(path, person, ".jsonl")) %>% enc2utf8() %>% parselog()
#   },
#         error=function(e) {
#         }
#   )
# }

# # write_csv("~/share/research/minor/r-console/logs_v3.csv", x = l)





# ### TODO: check it out
# library(tidyjson)
# tmp = jsonlite::stream_in(file("~/share/research/minor/2017_logs/addmitriev_1.jsonl"))





# ## title: "vle_log_2_new_both_cohorts"
# ## title: "vle_log_2_new_both_cohorts"


# path = "/principal/audit/r-console/"


# # for bash script


# list.names = list.files(path = path)
# list.names = str_replace_all(list.names,".jsonl","")
# list.names = setdiff(list.names, logs2$username %>% as.character() %>% unique()) # trying to find


# writeLines("~/share/research/minor/list.names", text = list.names, sep = "\n")


# # /srv/store/principal/audit/r-console - главное, не перезатереть!!!!!
# #setwd("~/share/research/minor/r-console/v2/r-console") # от 11 декабря

# parselog = function(log){
#   data = lapply(log, function(logline){
#     line = RJSONIO::fromJSON(logline)
#     return(data.frame(timestamp = line$timestamp, 
#                       #data = line$data,
#                       type = line$type, 
#                       username=line$username,
#                       pid=line$pid))
#   })
  
#   activity = plyr::rbind.fill(data)
#   activity$time = as.POSIXct(round(activity$timestamp/1000), origin="1970-01-01")
  
  
#   activity$weekday = ordered(weekdays(activity$time), levels=c("Понедельник",
#                                                                "Вторник",
#                                                                "Среда",
#                                                                "Четверг",
#                                                                "Пятница",
#                                                                "Суббота",
#                                                                "Воскресенье"
#                                                               ))
  
#   activity
# }



# list.names = list.files(path = path)
# list.names = str_replace_all(list.names,".jsonl","")

# # matching with 2nd year students' names
# # gs_key("1k1RceJMNdRsLMfHx0M0egK-NMdwu0qxGUWuPvjkfyd4") %>% gs_browse()
# tmp = gs_key("1k1RceJMNdRsLMfHx0M0egK-NMdwu0qxGUWuPvjkfyd4") %>% gs_read(ws = 1) %>% dplyr::select(name) # ведомость посещений

# logins2 = tmp$name
# nm = intersect(logins2, list.names) # 2 курс
# setdiff(logins2, list.names) # у них не было логов (не заходили)
  



# list.names = list.files(path = "~/share/research/minor/r-console/.")
# list.names = str_replace_all(list.names,".jsonl","")

# registerDoMC(8)
# l = foreach(person=list.names, .combine='rbind', .inorder=FALSE) %dopar% {
#   tryCatch({
#     readLines(str_c(path, person, ".jsonl")) %>% enc2utf8() %>% parselog()
#   },
#         error=function(e) {
#         }
#   )
# }

# write_csv("~/share/research/minor/vle/r-console/logs_v4.csv", x = l)



# # 2-3 курс отдельный лог
# list.names = list.files(path = "~/share/research/minor/r-console/v2/r-console/.")
# list.names = str_replace_all(list.names,".jsonl","")

# nm = list.names
# registerDoMC(8)

# l = foreach(person=nm, .combine='rbind', .inorder=FALSE) %dopar% {
#   tryCatch({
#     readLines(str_c("~/share/research/minor/r-console/v2/r-console/",person, ".jsonl")) %>% enc2utf8() %>% parselog()
#   },
#         error=function(e) {
#         }
#   )
# }


# # Checking whether logs of all users are extracted
# # setdiff(logs2$username %>% as.character() %>% unique(), list.names)
# setdiff(list.names, logs2$username %>% as.character() %>% unique()) # trying to find

# # nm = "gzmamedov"

# l = foreach(person=nm, .combine='rbind', .inorder=FALSE) %dopar% {
#   tryCatch({
#     parselog(readLines(str_c("~/share/research/minor/r-console/v2/r-console/",person, ".jsonl")))
#   },
#         error=function(e) {
#         }
#   )
# }




# library(ndjson)
# ndjson::stream_in()

# # Parselog alt
# parselog = function(log){
#   data = lapply(log, function(logline){
#     line = purrr::map(logline, jsonlite::fromJSON)
#     return(data.frame(timestamp = line$timestamp, 
#                       #data = line$data,
#                       type = line$type, 
#                       username=line$username,
#                       pid=line$pid))
#   })
  
#   activity = plyr::rbind.fill(data)
#   activity$time = as.POSIXct(round(activity$timestamp/1000), origin="1970-01-01")
  
  
#   activity$weekday = ordered(weekdays(activity$time), levels=c("Понедельник",
#                                                                "Вторник",
#                                                                "Среда",
#                                                                "Четверг",
#                                                                "Пятница",
#                                                                "Суббота",
#                                                                "Воскресенье"
#                                                               ))
  
#   activity
# }


# tmp = readLines(str_c("~/share/research/minor/r-console/v3/r-console/aabakhitova.jsonl")) %>% enc2utf8() %>% parselog()
# tmp = stream_in(file("~/share/research/minor/r-console/v3/r-console/aabakhitova.jsonl") %>% enc2utf8())


