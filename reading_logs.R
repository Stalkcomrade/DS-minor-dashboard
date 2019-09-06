

---
title: "1_reading_logs"
output: html_document
---

```{r}

library(magrittr)
library(dplyr)
library(RJSONIO)
library(lubridate)
library(stringr)
library(googlesheets)
library(readr)
library(doMC)
library(foreach)

path = "/srv/store/principal/audit/r-console/"


```



```{r}


data <- fromJSON(sprintf("[%s]", paste(readLines("~/share/research/minor/2017_logs/addmitriev_1.jsonl"),collapse=",")))


```



```{r}

line = RJSONIO::fromJSON(d)

lapply(d, function(logline) {
  line = RJSONIO::fromJSON(logline)
  return(data.frame(username=line$username))
})





library(rjson)
# c <- file(path, "r")
# l <- readLines(, -1L)

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


```

# Choosing particular student

```{r}

list.names = list.names[list.names == "addmitriev_1"]


```


```{r}


d = readLines("~/share/research/minor/2017_logs/addmitriev_1.jsonl") %>% enc2utf8()

# clean <- str_replace_all(d,'\\', "")
d = gsub("\\", "", d, fixed=TRUE)

j = d %>% parselog()

j = d %>% fromJSON()

readLines(str_c(path, "pozdniakovs", ".jsonl")) %>% enc2utf8() %>% parselog()  %>%  head()

registerDoMC(8)

l = foreach(person = list.names, .combine='rbind', .inorder=FALSE) %dopar% {
  tryCatch({
    readLines(str_c(path, person, ".jsonl")) %>% enc2utf8() %>% parselog()
  },
        error=function(e) {
        }
  )
}

# write_csv("~/share/research/minor/r-console/logs_v3.csv", x = l)

```


```{r}

library(tidyjson)
tmp = jsonlite::stream_in(file("~/share/research/minor/2017_logs/addmitriev_1.jsonl"))


```



##


---
title: "vle_log_2_new_both_cohorts"
output: html_document
---

```{r}

library(magrittr)
library(dplyr)
library(RJSONIO)
library(lubridate)
library(stringr)
library(googlesheets)
library(readr)
library(doMC)
library(foreach)

path = "/principal/audit/r-console/"


```



# for bash script


```{r}

list.names = list.files(path = path)
list.names = str_replace_all(list.names,".jsonl","")

list.names = setdiff(list.names, logs2$username %>% as.character() %>% unique()) # trying to find

#list.names = str_c("/students/pozdniakovs/share/research/minor/r-console/v2/r-console/",list.names, ".jsonl", "")

#write_lines("~/share/research/minor/list.names", x = list.names)

writeLines("~/share/research/minor/list.names", text = list.names, sep = "\n")

# write_file("~/share/research/minor/list.names", x = list.names)

# list.names=$(</students/pozdniakovs/share/research/minor/list.names)

```




```{r, root.dir}

# /srv/store/principal/audit/r-console - главное, не перезатереть!!!!!

#setwd("~/share/research/minor/r-console/v2/r-console") # от 11 декабря
# log = readLines("r-console/zzr.jsonl")
# log = readLines("r-console/budaevaa.jsonl")

```

```{r}

parselog = function(log){
  data = lapply(log, function(logline){
    line = RJSONIO::fromJSON(logline)
    return(data.frame(timestamp = line$timestamp, 
                      #data = line$data,
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

```


# matching with 2nd year students' names


```{r}

tmp = gs_key("1k1RceJMNdRsLMfHx0M0egK-NMdwu0qxGUWuPvjkfyd4") %>% gs_read(ws = 1) %>% dplyr::select(name) # ведомость посещений

# gs_key("1k1RceJMNdRsLMfHx0M0egK-NMdwu0qxGUWuPvjkfyd4") %>% gs_browse()

logins2 = tmp$name

nm = intersect(logins2, list.names) # 2 курс

```

```{r}

setdiff(logins2, list.names) # у них не было логов (не заходили)

```


```{r}
  

# l1 = lapply(nm[1:3], function(person){
#   tryCatch({
#     parselog(readLines(str_c("r-console/",person,".jsonl")))
#   },
#         error=function(cond) {
#             message(paste("URL does not seem to exist:", url))
#             message("Here's the original error message:")
#             message(cond)
#             # Choose a return value in case of error
#             return(NULL)
#         }
#   )
# })
  
#  readLines(str_c("~/share/research/minor/r-console/v2/r-console/", "adkuznetsova_1", ".jsonl")) %>% head()
```



```{r}

list.names = list.files(path = "~/share/research/minor/r-console/.")
list.names = str_replace_all(list.names,".jsonl","")


registerDoMC(8)

l = foreach(person=list.names, .combine='rbind', .inorder=FALSE) %dopar% {
  tryCatch({
    readLines(str_c(path, person, ".jsonl")) %>% enc2utf8() %>% parselog()
  },
        error=function(e) {
        }
  )
}

write_csv("~/share/research/minor/vle/r-console/logs_v4.csv", x = l)

```



# 2-3 курс отдельный лог


```{r}

list.names = list.files(path = "~/share/research/minor/r-console/v2/r-console/.")
list.names = str_replace_all(list.names,".jsonl","")

nm = list.names

registerDoMC(8)

l = foreach(person=nm, .combine='rbind', .inorder=FALSE) %dopar% {
  tryCatch({
    readLines(str_c("~/share/research/minor/r-console/v2/r-console/",person, ".jsonl")) %>% enc2utf8() %>% parselog()
  },
        error=function(e) {
        }
  )
}

# write_csv("~/share/research/minor/r-console/v2/r-console/logs_both_cohorts.csv", x = l)
 # write_csv("~/share/research/minor/r-console/v2/r-console/logs_both_cohorts_for_VIP_KAREPIN.csv", x = l)



```

# Checking whether logs of all users are extracted

```{r}


# setdiff(logs2$username %>% as.character() %>% unique(), list.names)

setdiff(list.names, logs2$username %>% as.character() %>% unique()) # trying to find

# nm = "gzmamedov"

l = foreach(person=nm, .combine='rbind', .inorder=FALSE) %dopar% {
  tryCatch({
    parselog(readLines(str_c("~/share/research/minor/r-console/v2/r-console/",person, ".jsonl")))
  },
        error=function(e) {
        }
  )
}


```




```{r}

library(ndjson)

ndjson::stream_in()

```

# Parselog alt

```{r}


parselog = function(log){
  data = lapply(log, function(logline){
    line = purrr::map(logline, jsonlite::fromJSON)
    return(data.frame(timestamp = line$timestamp, 
                      #data = line$data,
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


tmp = readLines(str_c("~/share/research/minor/r-console/v3/r-console/aabakhitova.jsonl")) %>% enc2utf8() %>% parselog()

library(tidyjson)
tmp = stream_in(file("~/share/research/minor/r-console/v3/r-console/aabakhitova.jsonl") %>% enc2utf8())


```

