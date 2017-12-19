#Loading the rvest package
library(rvest)
library(tidyverse)
library(splitstackshape) 



#Specifying the url for desired website to be scrapped
urls <- NULL
urls[1] <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'
for(page in 2:10){
  urls[page] <- paste0("http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature&page=",page,"&ref_=adv_nxt")
}

#Reading the HTML code from the website
webpages <- urls %>% map(read_html)

overall_data <- webpages %>% 
  map(html_nodes,".mode-advanced") %>% 
  map_df(map_df
         , ~list(rank = .x %>%
                    html_nodes(".text-primary") %>%
                    html_text() %>%
                    gsub(",","",.) %>%
                    as.numeric()
                 , title = .x %>%
                    html_nodes("h3 a") %>%
                    html_text %>%
                    as.character()
                 , imdb_score = .x %>% 
                    html_nodes("strong") %>% 
                    html_text %>% 
                    {if(length(.) == 0) NA else .} %>% 
                    as.numeric()
                 , meta_score = .x %>% 
                    html_nodes(".metascore") %>% 
                    html_text() %>% 
                    {if(length(.) == 0) NA else .} %>% 
                    as.numeric()
                 , genre = .x %>% 
                    html_nodes(".genre") %>% 
                    html_text() %>% 
                    {if(length(.) == 0) 'Missing' else .} %>% 
                    as.character()
                 )
         )
beepr::beep()

df_clean <- overall_data %>% 
  separate(genre, c("genre_1", "genre_2", "genre_3"), sep = ',') %>% 
  mutate(genre = paste0(genre_1, genre_2, genre_3)) %>% 
  mutate_at(vars(matches("genre")), funs(gsub("NA","",.)))

ggplot(df_clean, aes(rank, imdb_score)) + 
  geom_point() + 
  geom_smooth()

# For top 500 popular movies, more popularity = better imdb score
ggplot(df_clean %>% filter(rank < 500), aes(rank, imdb_score)) + 
  geom_point()

# For movies outside the top 500, popularity has little relationship with imdb score
ggplot(df_clean %>% filter(rank > 500, rank < 1000), aes(rank, imdb_score)) + 
  geom_point()

