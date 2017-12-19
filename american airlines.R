#Loading the rvest package
library(rvest)
library(tidyverse)
library(stringr)

Sys.setenv(TZ = "America/Los_Angeles")

#Specifying the url for desired website to be scrapped
url <- "https://www.aa.com/homePage.do"
session <- html_session(url)
form <- html_form(session)[[3]]
filled_form <- set_values(form
                          , `loginId` = "nmarkspdx@gmail.com"
                          , `lastName` = "Marks"
                          , `password` = "Billy1793")
output <- submit_form(session,filled_form)

test <- jump_to(output, "https://www.aa.com/loyalty/profile/activity")



