#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)


library(tidyverse)
library(jsonlite)

## TODO: prepare function
prepare_students_reports = function(course_id) {

  vf = jsonlite::fromJSON(str_c("course_grades_", course_id, ".json"),
                          simplifyVector = FALSE)

  vf[[2]] # object of arrays
  vf[[2]] %>% class()

  df = tibble(user = numeric(), score = numeric(), course = numeric(), rank = numeric())

  vf[[2]] %>% map(.f = function(.x) {

    ## not the best practice
    df <<- add_row(.data = df,
                   user = .x$user,
                   score = .x$score,
                   course = .x$course,
                   rank = .x$rank)

  })

  write_csv(df, str_c("course_df_", course_id, ".csv"))
}

prepare_students_reports(args[1])


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

