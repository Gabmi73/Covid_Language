# Get vax_ling from script 02_LA

library(tidyverse)
library(cowplot)
library(ggpubr)
library(xml2)
library(wordcloud)
library(wordcloud2)
library(tidytext)


# LOAD SENTIMENT LEXICON

# Russo, Irene; Frontini, Francesca and Quochi, Valeria, 2016, OpeNER Sentiment Lexicon Italian - LMF, ILC-CNR
# for CLARIN-IT repository hosted at Institute for Computational Linguistics "A. Zampolli", National Research Council, in Pisa, 
# http://hdl.handle.net/20.500.11752/ILC-73.

isl <- read_xml("https://raw.githubusercontent.com/opener-project/VU-sentiment-lexicon/master/VUSentimentLexicon/IT-lexicon/it-sentiment_lexicon.lmf") 
ISL <- tibble(  
  lemma = xml_attr(xml_find_all(isl, ".//Lemma"), "writtenForm"),
  polarity = as.character(xml_attr(xml_find_all(isl, ".//Sentiment"), "polarity"))) %>% 
  mutate(polarity = ifelse(polarity == "nneutral", "neutral", polarity)) %>% 
  mutate(polarity = ifelse(polarity == "positive", 1, ifelse(polarity == "negative", -1, 0))) %>% 
  filter(!is.na)

# Extracting negators
negators <- vax_clean %>% 
  filter(pos == "NEGATOR")

# Polarity scoring for each token
sent_words <- vax_clean %>%
  inner_join(ISL) %>% 
  filter(polarity != 0) %>% # getting rid of neutral
  add_row(negators) %>% # adding negators
  arrange(doc_id, token_id) %>%
  mutate(polarity = ifelse(is.na(polarity) & pos == "NEGATOR", -1, polarity))

# Sentiment by tweets: sum of scores of single words per each tweet
sent_tweets <- sent_words %>%
  group_by(doc_id, date) %>% 
  summarise_at(.vars = c("polarity"), sum) %>%
  ungroup() 

# Sentiment by day: sum of tweets score
# 2021-03-18 has a very positive score and can be considered an outlier
# I have adjusted this value to 1,6 (unique max/ min value)
sent_day <- sent_tweets %>% 
  group_by(date) %>% 
  summarise_at(.vars = c("polarity"), sum) %>% 
  mutate(polarity = scale(polarity)) %>% 
  ungroup() %>% 
  mutate(polarity = round(polarity, digits = 2)) %>%
  mutate(polarity = replace(polarity, date == "2021-03-18", 1.6))
  
# CHARTS

# daily trendline's sum of tweets
main_p <- sent_day %>% 
  ggplot(aes(x =  date, y = polarity, fill = polarity)) +
  geom_col(na.rm = TRUE, position = position_identity()) +
  geom_hline(yintercept = .0, linetype = "dashed", color = 
               "dodgerblue3") +
  stat_smooth(se = FALSE, color = "hotpink2") +
  theme_bw() +
  xlab(NULL) +
  ylab("Polarity") +
  labs(title = "Fig 2 -   Polarity of Tweets per day",
       subtitle = paste0("Mean ", round(mean(sent_day$polarity), digits = 2),
                         "    SD ", round(sd(sent_day$polarity), digits = 2),
                         "    Q2 ", round(quantile(sent_day$polarity, probs = 0.25), digits = 2),
                         "    Median ", round(median(sent_day$polarity), digits = 2),
                         "    Q4 ", round(quantile(sent_day$polarity, probs = 0.75), digits = 2),
                         "    Max ", round(max(sent_day$polarity), digits = 2),
                         "    Min ", round(min(sent_day$polarity), digits = 2)),
       caption = paste0("From 15 March to 16 May 2021: ",
                        round(length(sent_tweets$polarity)/length(vax_base$doc_id)*100,
                              digits = 1), "% of scored sentiment tweets and ",
                        round(length(sent_words$doc_id)/length(vax_clean$doc_id)*100,
                              digits = 1), "% of scored sentiment lemmas")) +
  scale_y_continuous(breaks=function(x) seq(from = -1.60, to = max(x), by = 0.3),
                     labels = scales::label_number_auto()) +
  scale_x_date(breaks = function(x) seq.Date(from = as.Date("2021-03-15"), to = as.Date("2021-05-17"), by = 3),
               date_labels = "%b-%d") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.title = element_blank(),
        legend.position = "none",
        panel.grid.minor.y = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank())


inset <- ggplot(sent_day, aes(polarity)) +
  geom_density(color = 4, lwd = 1, linetype = 1, bw = "SJ") +
  ylab(NULL) +
  xlab(NULL) +
  labs(subtitle = "Density Distribution of Polarity") +
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.minor.x = element_blank())

plot <- ggdraw() +
  draw_plot(main_p) +
  draw_plot(inset, x = 0.68, y = 0.71, width = .3, height = .20)

ggsave(filename = "sentiment.png",
       path = "./images",
       plot = plot,
       width = 22, 
       height = 16,
       units = "cm",
       dpi = 300)

# Tweets per day with statistics 
counts_n <- vax_base %>% group_by(date) %>% count() %>% ungroup() %>% rename("All" = n)
counts_p <- sent_tweets %>% group_by(date) %>% count() %>% ungroup() %>% rename(Polarized = n)
counts <- full_join(counts_n, counts_p) %>% 
  gather("All", Polarized, key = "all", value = "n")

stats_tab <- counts %>%
  group_by(all) %>% 
  summarise(Mean = round(mean(n), digits = 0),
            SD = round(sd(n), digits = 0),
            Q2 = round(quantile(n, probs = 0.25), digits = 0),
            Median = round(median(n), digits = 0),
            Q4 = round(quantile(n, probs = 0.75), digits = 0),
            Max = round(max(n), digits = 0),
            Min = round(min(n), digits = 0)) %>% 
  rename(Tweets = all)

# Table of statistics
texttab <- ggtexttable(stats_tab,
                       rows = NULL, theme = ttheme(base_style = "mOrangeWhite",
                                                   base_colour = "#003152")) %>%
           tab_add_title("Statistics (values rounded)", color = "#003152", face=c("bold.italic"))

plot_c <- counts %>% 
  ggplot(aes(x = date, y = n, fill = all)) +
  geom_col(position = "identity") +
  xlab(NULL) +
  ylab("Number of Tweets") +
  labs(title = "Fig 3   - Distribution of Tweets per day") +
  theme(panel.grid = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1),
        axis.ticks.x.bottom = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position=c(.90,.65)) +
  guides(fill=guide_legend(title="Tweets")) +
  scale_x_date(breaks = function(x) seq.Date(from = as.Date("2021-03-15"), to = as.Date("2021-05-16"), by = 1),
               date_labels = "%b-%d",
               limits = c(as.Date("2021-03-14"),as.Date("2021-05-17")), expand = c(0, 0)) +
  scale_fill_manual(values = c("orange","deepskyblue4")) +
  scale_y_continuous(limits=c(0,8000), expand = c(0, 0))

plot_all <- ggdraw() +
  draw_plot(plot_c) +
  draw_plot(texttab, x = 0.62, y = 0.70, width = .3, height = .3)

ggsave(filename = "tw_day.png",
       path = "./images",
       plot = plot_all,
       width = 32, 
       height = 18,
       units = "cm",
       dpi = 300)

# WORDCLOUDS

# 1) NEG and POS

sent_words %>%
  filter(!str_detect(pos, "NEGATOR")) %>%
  count(lemma, polarity, pos, sort = TRUE) %>% 
  mutate(polarity = ifelse(polarity == 1, "Positive", "Negative")) %>% 
  filter(polarity == "Negative") %>% 
  select(lemma, n) %>% 
  slice(1:250) %>% 
  letterCloud(word = "NEG", wordSize = 0.7, shuffle = FALSE,
              backgroundColor = "mintcream")

dev.off()

sent_words %>%
  filter(!str_detect(pos, "NEGATOR")) %>%
  count(lemma, polarity, pos, sort = TRUE) %>% 
  mutate(polarity = ifelse(polarity == 1, "Positive", "Negative")) %>%  
  filter(polarity == "Positive") %>% 
  select(lemma, n) %>% 
  slice(1:250) %>% 
  letterCloud(word = "POS", wordSize = 0.7, shuffle = FALSE,
              backgroundColor = "mintcream")

dev.off()

# 2) NOUNS AND ADJECTIVES POLARIZED

figPath = system.file("examples/t.png",package = "wordcloud2")

w2 <- words %>%
  filter(str_detect(pos, c("NOUN|ADJ"))) %>%
  select(word = lemma, freq = n) %>% 
  mutate(word = factor(word)) %>%
  slice(1:230) %>% 
  wordcloud2(figPath = figPath, backgroundColor = "mintcream",
             shuffle = FALSE)


# creating labelled dataset

vax_base_rid <- vax_base %>% select(doc_id, date, text, txt_original)

labelled_dataset <- sent_tweets %>% 
  mutate(label = ifelse(polarity == -1, 0, 1)) %>% 
  left_join(vax_base_rid) %>% 
  select(doc_id, date, text, txt_original, label)
  
  
  
