#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)


if(length(args) == 0) {
  packrat::on()
  args = c(1403)
}

library(tidyverse)
# library(jsonlite)

## FIXME:
setwd("/students/stlkcmrd/DS-minor-dashboard")


## FIXME: replace Nulls with zeros (for now)
rewrite_nulls = function(x) {
  if (is.null(x)) {
    return(0)
  } else {
    return(x)
  }
}

## change paths
## prepare function

prepare_students_reports = function(course_id) {

  ## create a folder if doesn't exist
  if (sprintf("course_%s", course_id) %in% 
      str_replace(pattern = "./data/processed/stepik/", replacement = "", list.dirs("./data/processed/stepik"))) {
    print(sprintf("Folder for processed data (csv) per %s already exists", course_id))
  } else {
    print(sprintf("Creating a folder for processed data (csv) per %s", course_id))
    dir.create(sprintf("./data/processed/stepik/course_%s", course_id))
  }

browser()
## iterates over all json files 

i = 0
for (page in list.files(sprintf("./data/raw/stepik/course_%s/", course_id))) {

  i = i + 1
  df = NULL
  ## pagination
  vf = jsonlite::fromJSON(sprintf("./data/raw/stepik/course_%s/course_grades_%s_page_%s.json", course_id, course_id, i),
                          simplifyVector = FALSE)


  df = tibble(user = numeric(), score = numeric(), course = numeric(), rank = numeric())

  tryCatch({

vf[[2]] %>% map(.f = function(.x) {

    ## not the best practice
    df <<- add_row(.data = df,
                   user = .x$user,
                   score = .x$score,
                   course = .x$course,
                   rank = rewrite_nulls(.x$rank))

  })
  write_csv(df, sprintf("./data/processed/stepik/course_%s/course_df_%s_page_%s.csv", course_id, course_id, i))

  }, error = function(cond) {

    print(sprintf("Error %s", cond))
    print(sprintf("Error %s in course, %s page ", course_id, i))

  })
}
}

prepare_students_reports(args[1])
