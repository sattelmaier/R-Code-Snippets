# code is explained in the corresponding Markdown file

library(readr)
library(httr)
library(rvest)
library(dplyr)
library(stringr)
library(taskscheduleR)

getwd()
setwd("C:/Users/maiks/Documents/R/R-Code-Snippets/Web Scraping")

df <- data.frame(band = character(),
                 album = character(),
                 release = as.Date(character()),
                 issue = as.numeric(),
                 add_time = as.Date(character()),
                 lead = character(),
                 main = character(),
                 stringsAsFactors=FALSE)

df <- read_csv("visions_album_of_the_week", 
               col_types = cols(add_time = col_datetime(format = "%Y-%m-%d %H:%M:%S"),
                                release = col_date(format = "%Y-%m-%d"))) 

df <- df[-1]

visions_url = GET('https://www.visions.de/platten/platte-der-woche/')
status_code(visions_url) # check availability of website: 200 = okay

visions_html <- read_html("https://www.visions.de/platten/platte-der-woche/")

name_raw <- visions_html %>% 
  html_nodes('h1') %>% # 'h1'-argument extracted from web-page html source code; using css method
  html_text() %>%
  str_squish() # remove whitespaces

band <- word(name_raw, 1, sep = "\\-") %>%
  str_squish()
album <- word(name_raw, 2, sep = "\\-") %>%
  str_squish() 

release <- visions_html %>% 
  html_nodes(xpath = '/html/body/div[1]/div[2]/div[4]/div[2]/div[2]/ul/li[1]') %>%  
  html_text() %>%
  str_squish() %>%
  gsub(pattern = "[^0-9.]", replacement = "") %>% # clean date
  as.Date(tryFormats = c("%d.%m.%Y"))

issue_raw <- visions_html %>% 
  html_nodes(xpath = '/html/body/div[1]/div[2]/div[4]/div[2]/div[2]/ul/li[3]') %>%
  html_text() %>%
  str_squish() %>% # remove whitespaces
  gsub(pattern = "[^0-9]", replacement = "") %>%
  as.numeric()

lead <- visions_html %>% 
  html_nodes(xpath = '//*[@id="cf"]/div/p/strong') %>% 
  html_text() %>%
  str_squish()

main <- visions_html %>% 
  html_nodes(xpath = '//*[@id="cf"]/div[position() = 4]') %>% 
  html_text() %>%
  str_squish()

time <- Sys.time()

album <- tibble('band' = band,
                'album' = album,
                'release' = release, 
                'issue' = issue_raw, 
                'add_time' = time,
                'lead' = lead, 
                'main' = main)

if(!(album$band %in% df$band) && !(album$album %in% df$album)){
  df = rbind(album,df)
} else {print('Album is already in the data frame.')}

write.csv(df, file = 'visions_album_of_the_week')

