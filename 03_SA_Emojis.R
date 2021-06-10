# Get vax_base from script 01_Vax_Base

library(tidyverse) 
library(rvest)
library(ggtext)
library(grid)
library(scales)

# 1) Scraping and reshaping emoji web table reduced for the purpose of this project.

emoji_sent <- tibble(
  map_df(
    html_table(
      read_html("http://kt.ijs.si/data/Emoji_sentiment_ranking/index.html")),
    bind_rows)) %>% 
  select(c(
    icon = Char,
    emoji_name = "Unicode name",
    emoji_score = "Sentiment score[-1...+1]")) %>% 
    mutate(unicode = utf8::utf8_encode(icon))
          # for easy merging with tweets unicodes extracted
  
## 2) Creation of emoji separate table

emojis <- vax_base %>% 
  separate_rows(emojis, sep = "\\s") %>% 
  inner_join(emoji_sent, by = c("emojis" = "unicode")) %>%
  select(c(doc_id, date, icon, emoji_score, emoji_name)) %>% 
  filter(!str_detect(emoji_name, "^REGIONAL\\s+|^LARGE RED CIRCLE+|
                     |^WHITE RIGHT POINTING BACKHAND INDEX+|
                     |^WHITE DOWN POINTING BACKHAND INDEX+|
                     |^WHITE UP POINTING BACKHAND INDEX+|
                     |^LARGE BLUE CIRCLE+|SMALL BLUE DIAMOND+")) %>%
        # get rid of regional indicator symbols and other not-emotive emojis
  group_by(icon) %>% 
  count(icon, emoji_name, emoji_score) %>%
  ungroup() %>%
  arrange(desc(n)) %>% 
  mutate(n_rank = cume_dist(n)) %>% 
  relocate(n_rank, .after = "n") 

# https://www.hvitfeldt.me/blog/real-emojis-in-ggplot2/
# for the following two image scraping functions

emoji_to_link <- function(x) {
  paste0("https://emojipedia.org/emoji/",x) %>%
    read_html() %>%
    html_nodes("tr td a") %>%
    .[1] %>%
    html_attr("href") %>%
    paste0("https://emojipedia.org/", .) %>%
    read_html() %>%
    html_node('div[class="vendor-image"] img') %>%
    html_attr("src")
}

link_to_img <- function(x, size = 25) {
  paste0("<img src='", x, "' width='", size, "'/>")
}

# Apply functions
top_50_emojis <- emojis %>%
  slice(1:50) %>%
  mutate(url = map_chr(icon, slowly(~emoji_to_link(.x), rate_delay(1))),
         label = link_to_img(url))

# write_csv(top_50_emojis, "top_50_emojis.csv")

## 3) CHARTS

emo_n <- vax_base[,"emojis"] %>% 
  separate_rows(emojis, sep = "\\s") %>% 
  inner_join(emoji_sent, by = c("emojis" = "unicode")) %>%
  summarise(
    across(c("icon"), length),
    across(c("emojis"), n_distinct)) %>%
  mutate(tweets = length(vax_base$doc_id)) %>%
  mutate(emoj_vs_tw = round(icon/tweets*100, digits = 2)) %>% 
  rename(tot_emoj = icon, emoj_unique = emojis)

plot <- top_50_emojis %>% 
  ggplot(aes(y = n_rank, x = emoji_score, label = label)) +
  ggtext::geom_richtext(aes(x = emoji_score), fill = NA, label.color = NA,
                        label.padding = grid::unit(rep(0, 4), "pt")) +
  theme_minimal()+
  theme(axis.line = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())+
  ylab("Cumulative Rank") +
  xlab("Emoji Sentiment Score") +
  geom_vline(xintercept = 0.00, linetype = "dashed", color="red") +
  labs(title = "Top 50 Emojis Sentiment Score Distribution",
       subtitle = paste0(length(emojis$icon), " unique Emojis out of a total of ",
                         emo_n$tot_emoj),
       caption = paste0("Percent of Emojis vs overall nr. of Tweets: ",
                        emo_n$emoj_vs_tw, " %")) +
  scale_x_continuous(breaks=function(x) seq(from = min(x), to = max(x), by = 0.20),
                     label = scales::label_number(accuracy = 0.01)) 

ggsave(filename = "top50_emojis.png",
       path = "./images",
       plot = plot,
       width = 20, 
       height = 14,
       units = "cm",
       dpi = 300)
