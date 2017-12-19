library(rvest)
library(tidyverse)

aljazeera_homepage <- read_html("http://www.aljazeera.com/")

aljazeera_homepage %>% 
  html_nodes(".top-sec-smalltitle") %>% 
  html_text()

main_articles <- aljazeera_homepage %>% 
  mutate(main = map(., ~(. %>% 
                           html_nodes(".top-sec-smalltitle") %>%
                           html_text())))
  , media_top = .x %>% 
                  html_nodes(".media-body-head")
                , media_second = .x %>% 
                  html_nodes(".top-section-row3-lt-heading")))



