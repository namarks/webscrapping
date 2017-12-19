# To scrap dynamic webpages, Rvest will not work, so I'm testing RSelenium
install.packages("RSelenium")
vignette("RSelenium-docker", package = "RSelenium")

library(RSelenium)
library(rvest)
#start RSelenium
checkForServer()
startServer()
remDr <- remoteDriver()
remDr$open()

#navigate to your page
remDr$navigate("http://www.linio.com.co/tecnologia/celulares-telefonia-gps/")

#scroll down 5 times, waiting for the page to load at each time
for(i in 1:5){      
  remDr$executeScript(paste("scroll(0,",i*10000,");"))
  Sys.sleep(3)    
}

#get the page html
page_source<-remDr$getPageSource()

#parse it
html(page_source[[1]]) %>% html_nodes(".product-itm-price-new") %>%
  html_text()