
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


# ## title: "vle_log_2_new_both_cohorts"
# list.names = list.files(path = path)
# list.names = str_replace_all(list.names,".jsonl","")
# list.names = setdiff(list.names, logs2$username %>% as.character() %>% unique()) # trying to find
# setdiff(logins2, list.names) # у них не было логов (не заходили)


# # Checking whether logs of all users are extracted
# # setdiff(logs2$username %>% as.character() %>% unique(), list.names)
# setdiff(list.names, logs2$username %>% as.character() %>% unique()) # trying to find


# tmp = readLines(str_c("~/share/research/minor/r-console/v3/r-console/aabakhitova.jsonl")) %>% enc2utf8() %>% parselog()
# tmp = stream_in(file("~/share/research/minor/r-console/v3/r-console/aabakhitova.jsonl") %>% enc2utf8())



