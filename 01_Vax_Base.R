library(rtweet)
library(tidyverse)

# Create your personal API_access and then search tweets:

tweets <- search_tweets("#vaccinoCovid OR #VaccinoAntiCovid OR #vaccino OR #PfizerVaccine OR #AstraZeneca",
                        include_rts = FALSE,
                        lang = "it",
                        retryonratelimit = TRUE)

# Saving each daily inquiry in a favourite folder/ directory

setwd("./Tweets_Vaccino")
write_as_csv(tweets, paste0(lubridate::today(), "_vax_tweets_ORIG"))

# Uploading all saved files (e.g. by a pattern, I've used "Year")

tweets_all <- list.files(pattern = "^2021", full.names = TRUE) %>%
  map_df(~ read_twitter_csv(.)) %>% 
  distinct(status_id, .keep_all = TRUE) # mind removing duplicates!

# Creating Vax Table Base, with a first cleaning (only tweets peculiarities)

vax_base <- tweets_all %>% 
  separate(created_at, into = c("date", "time"), sep = "\\s") %>%
  mutate(date = as.Date(date)) %>%
  mutate(doc_id = row_number()) %>% 
  mutate(txt_original = text) %>% 
  mutate(text = str_squish(text),
         text = str_replace_all(text, "[[:cntrl:]]+", " "),
         text = str_replace_all(text, "\\\\n+", " "),
         text = str_replace_all(text, "\\\\r+", " "),
         text = str_remove_all(text,  "https://t.co/[a-z,A-Z,0-9]*"),
         text = str_remove_all(text, "&gt+"),
         text = str_remove_all(text, "@\\w+"),
         text = str_remove_all(text, "#\\w+"),
         text = str_remove_all(text, "\\<U[^\\>]*\\>+"),
         text = str_replace_all(text, "[:punct:]|°|[:digit:]|\\+|=|\\||~|\\$|€|&|¦|×", " "),
         text = str_remove_all(text, "\\^+"),
         text = str_remove_all(text, "\\samp\\s+"),
         text = tolower(text),
         text = str_squish(text)) %>% 
  mutate(hashtags = str_remove_all(hashtags, '^c\\(+|\\)+|"')) %>%
  mutate(emojis = as.character(str_extract_all(txt_original,"<U\\+(........)>"))) %>% # extracting emojis in unicode format
  mutate(emojis = str_remove_all(emojis, "character\\(0\\)")) %>%
  mutate_if(is.character, list(~na_if(.,""))) %>%
  mutate(emojis = tolower(emojis)) %>% 
  mutate(emojis = str_remove_all(emojis, 'c\\(|"|\\)')) %>% 
  mutate(emojis = str_replace_all(emojis, "<u\\+","\\\\U")) %>%
  mutate(emojis = str_remove_all(emojis, ">|,")) %>%
  select(c(doc_id, date, time, text, hashtags, txt_original, screen_name,
           favourites_count, followers_count, retweet_count, statuses_count, 
           quote_count, reply_count, verified, name, description, coords_coords,
           bbox_coords, emojis))
