#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if(length(args) > 0) {
  packrat::on("DS-minor-dashboard")
  }

library(magrittr)
library(dplyr)
library(lubridate)
library(stringr)
library(readr)

library(rjson)
library(RJSONIO)

library(furrr)
library(purrr)

library(here)

main_path = here::here("DS-minor-dashboard")
path = "/srv/store/principal/audit/r-console/"
list_names = list.files(path = path)


## only jsonl without an extension is returned
list_names_trunc = purrr::map(list_names, .f = function(x) {
  if (str_detect(x, ".jsonl")) { 
    return(x) 
  }
}) %>% purrr::flatten_chr() ## returns vector


## FIXME: register parallel BEFORE returning future_map
## run in parallel
## https://davisvaughan.github.io/furrr/


#' parses EACH LINE == entry of jsonl
#'
#' @param fullpath - fullpath to JSONL
#'
#' @return dataframe with user's logs
#' @export
#'
#' @examples
prepare_user_log = function(fullpath) {
  
  personal_log = fullpath %>% 
    readLines(-1L, warn = FALSE) %>% enc2utf8() %>% purrr::map(function(entry) {
      
      # COL <<- COL + 1
      ## returns one line of individual log
      ## validating wrong json lines
      ## and omitting them
      if(jsonlite::validate(entry)) {
        
        interm_df = entry %>% RJSONIO::fromJSON()
        df_to_return =  data.frame(timestamp =  interm_df$timestamp, 
                                   # data =     interm_df$data,
                                   type =     as.character(interm_df$type), 
                                   username = as.character(interm_df$username),
                                   pid =      interm_df$pid)
        return(df_to_return)
      }
    }) %>% plyr::rbind.fill()
  
  return(personal_log)
  
}


#' Read individual logs of server users
#'
#' @param x - identifier for the logs to be read from 1 to x
#' @param future_version - whether to use with future or not
#'
#' @return returns combined logs of several users
#' @export 
#'
#' @examples
synch_parse_logs = function(x, future_version) {
  
  ## preparing for futures
  # plan(multiprocess)
  
  no_cores <- availableCores() - 1
  plan(multicore, workers = no_cores)

  ## checks which function to use
  mapper = ifelse(future_version, future_map, purrr::map)
  
  ## parses individual logs of each user
  final_list_of_logs = list_names_trunc[1:x] %>% mapper(function(jsonl) {
    
    fullpath = str_c(path, jsonl)
    
    ## binding dataframes from list
    activity = prepare_user_log(fullpath)
    
    return(activity)
       
  })
  
  return(final_list_of_logs)
  
}


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

## making callable from the command line
## example: Rscript reading_logs.R 10 TRUE

logs_list = synch_parse_logs(args[1], args[2])
logs_list %>% future_map(.f = ~write_personal_log(.x))
