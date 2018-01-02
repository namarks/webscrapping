#Loading the rvest package
library(rvest)
library(tidyverse)

final <- readRDS("uscis_progress.rds")

Sys.setenv(TZ = "America/Los_Angeles")

#Specifying the url for desired website to be scrapped
url <- "https://egov.uscis.gov/foiawebstatus/index.jsp#main-content"
session <- html_session(url)
form <- html_form(session)[[2]]
filled_form <- set_values(form, `cn` = "NRC2017167920")
output <- submit_form(session,filled_form)

status_raw <- output %>% 
  html_nodes("p") %>% 
  html_text() %>% 
  .[5]

status_tag <- regexpr("currently number",status_raw)

status_parsed <- status_raw %>% 
  substr(.,status_tag+attr(status_tag,"match.length")+1,nchar(status_raw)) %>% 
  strsplit(.,"of|\\r|\\n|\\t") %>% 
  .[[1]] %>% 
  as_data_frame() %>% 
  filter(row_number()<3) %>% 
  cbind(.,data_frame(variable = c("position","wait_length"))) %>% 
  spread(variable, value) %>% 
  mutate(timestamp = Sys.time())

final <- bind_rows(final,status_parsed) %>% 
  mutate(position = ifelse(position=='',0,position))
final

final_long <- final %>% 
  gather(variable, position, -timestamp) %>% 
  mutate(position = as.numeric(position)
         , time = lubridate::round_date(timestamp, unit = "hour"))

ggplot(final_long, aes(time, position, shape = variable, size = 5, color = variable, alpha = .5)) + 
  geom_point() +
  theme(legend.text = element_text(size = 15)) + 
  guides(size = FALSE, alpha = FALSE
         , shape = guide_legend(override.aes = list(size = 5)))

saveRDS(final, file = "uscis_progress.rds")
