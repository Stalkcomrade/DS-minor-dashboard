#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)


if(length(args) > 0) {
  packrat::on("DS-minor-dashboard")
} else {
  args = c(2)
}



library(magrittr)
library(dplyr)
library(lubridate)
library(stringr)
library(readr)

library(rjson)
library(RJSONIO)

library(doMC)

library(here)
library(tictoc)


main_path = here::here("DS-minor-dashboard")

path = "/srv/store/principal/audit/r-console/"
list_names = list.files(path = path)

tic("doMC")


parselog = function(log){
  
  data = lapply(log, function(logline){
    
    # COL <<- COL + 1
    ## returns one line of individual log
    ## validating wrong json lines
    ## and omitting them
    if(jsonlite::validate(logline)) {
      
    line = RJSONIO::fromJSON(logline)
    
    return(data.frame(timestamp = line$timestamp,
                      data = line$data,
                      type = line$type,
                      username = line$username,
                      pid = line$pid))
  
    }
  })
  
  activity = plyr::rbind.fill(data)

  return(activity)
}


## only jsonl without an extension is returned
list_names_trunc = purrr::map(list_names, .f = function(x) {
  if (str_detect(x, ".jsonl")) { 
    return(x) 
  }
}) %>% purrr::flatten_chr() ## returns vector


#' Writes csv file to data/raw/vle
#'
#' @param x - data frame to write
#'
#' @return
#' @export
#'
#' @examples
write_personal_log = function(x) {
  write_csv(x = x, path = str_c(main_path, sprintf("/data/raw/vle/%s.csv", levels(x$username))))
}

write_unitred_log = function(x) {
  write_csv(x = x, path = str_c(main_path, "/data/raw/vle/UNITED.csv"))
}



registerDoMC(8)

l = foreach(person = list_names_trunc[1:args[1]], .combine='rbind', .inorder=FALSE) %dopar% {
  tryCatch({
    readLines(str_c(path, person)) %>% enc2utf8() %>% parselog()
  },
        error=function(e) {
        }
  )
}

## FIXME: into utils and export after
wait_until_sc = function(FN, argument) {
  
  r <- NULL
  while( is.null(r)) {
    try(
      r <- FN(argument)
    )
  } 
  
}

wait_until_sc(write_unitred_log, l)

toc()

# # Checking whether logs of all users are extracted
# # setdiff(logs2$username %>% as.character() %>% unique(), list.names)