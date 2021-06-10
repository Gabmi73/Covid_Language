# STATISTICS
# Get vax_base from script 01_Vax_Base
# Get vax_clean from script 02_LA
# Get emoji_Sent form 03_SA_Emojis

library(tidyverse)
library(cowplot)
library(ggpubr)

## 1) DESCRIPTIVES

# hashtags
hash <- vax_base %>%
  select(doc_id, date, hashtags) %>% 
  filter(trimws(hashtags) != "") %>% 
  separate_rows(hashtags) %>% 
  mutate(hashtags = tolower(hashtags),
         hashtags = str_replace_all(hashtags, "astraz\\w+ *", "astrazeneca"),
         hashtags = str_replace_all(hashtags, "pfiz\\w+ *|biont\\w+ *", "pfizer"),
         hashtags = str_replace_all(hashtags, "johns\\w+ *", "j&j"),
         hashtags = str_replace_all(hashtags, "modern\\w+ *", "moderna"),
         hashtags = str_replace_all(hashtags, "sput\\w+ *", "sputnik"),
         hashtags = str_replace_all(hashtags, "tromb\\w+ *", "trombosi")) %>% 
  filter(nchar(hashtags) > 1) %>%
  group_by(hashtags) %>% 
  count(sort = TRUE) %>% 
  ungroup()

# Statistics table

stat <- vax_base %>% 
  summarise(
    across(c("doc_id", "date", "screen_name"), n_distinct),
    across(c("retweet_count", "verified"), sum)) %>%
  mutate("Mean Tweets per day (rounded)" = round(length(vax_base$doc_id)/length(unique(vax_base$date)), digits = 0)) %>% 
  rename(Tweets = doc_id, Days = date, Users = screen_name,
         Retweets = retweet_count, "Users verified" = verified) %>% 
  mutate("Hashtags all" = sum(hash$n),
         "Hahstags unique" = length(hash$hashtags)) %>% 
  gather(., "Descriptives", "N")

stattab <- ggtexttable(stat, rows = NULL, theme = ttheme(base_style = "mViolet",
                                                         base_colour = "#003152")) %>%
  tab_add_title("Descriptives", color = "#003152", face=c("bold.italic"))

ggsave(filename = "Descritpives.png",
       path = "./images",
       plot = stattab ,
       width = 16, 
       height = 10,
       units = "cm",
       dpi = 300)

## 2) LEXICOMETRY

lexmetFun <- function(tab1, tab2, tab3) {
  
  mode1 <- tab1 %>%
    count(token, sort=TRUE) %>% 
    slice(1)
  
  # All tokens
  tab1 <- tab1 %>%
    count(token, sort=TRUE) %>% 
    summarise(Tokens = sum(n),
              Types = n(),
              "Unique Words (hapax) %" = round(sum(n[n==1]/Types*100, digits = 2)),
              Mode = paste0('"', mode1$token, '"', " : ", mode1$n),
              Mean = round(mean(n), digits = 2),
              SD = round(sd(n), digits = 2)) %>% 
    gather(., "Metric", "value") 
  
  # Tokens Cleaned
  mode2 <- tab2 %>%
    count(token, sort=TRUE) %>% 
    slice(1)
  
  tab2 <- tab2 %>%
    count(token, sort=TRUE) %>% 
    summarise(Tokens = sum(n),
              Types = n(),
              "Unique Words (hapax) %" = round(sum(n[n==1]/Types*100, digits = 2)),
              Mode = paste0('"', mode2$token, '"', " : ", mode2$n),
              Mean = round(mean(n), digits = 2),
              SD = round(sd(n), digits = 2)) %>% 
    gather(., "Metric", "value") 
  
  # Lemmas Cleaned
  mode3 <- tab3 %>%
    count(lemma, sort=TRUE) %>%
    slice(1)
  
  tab3 <- tab3 %>%
    count(lemma, sort=TRUE) %>%
    summarise(Lemmas = n(),
              "Unique Words (hapax) %" = round(sum(n[n==1]/Lemmas*100, digits = 2)),
              Mode = paste0('"', mode3$lemma, '"', " : ", mode3$n),
              Mean = round(mean(n), digits = 2),
              SD = round(sd(n), digits = 2)) %>% 
    gather(., "Metric", "value") 
  
  tab <- full_join(tab1, tab2, by = "Metric") %>%
    full_join(tab3, by = "Metric") %>% 
    rename("All Tokens" = value.x, "Cleaned Tokens" = value.y, "Cleaned Lemmas" = value)
  
  return(tab)
}

lexMet <- lexmetFun(vax_ling, vax_clean, vax_clean)

lexMetTab <- ggtexttable(lexMet, rows = NULL, theme = ttheme(base_style = "mCyan",
                                                             base_colour = "#003152")) %>%
  tab_add_title("Lexicometry", color = "#003152", face=c("bold.italic"))


ggsave(filename = "Lexicomentry.png",
       path = "./images",
       plot = lexMetTab,
       width = 16, 
       height = 8,
       units = "cm",
       dpi = 300)