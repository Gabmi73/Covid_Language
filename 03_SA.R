# Get vax_ling from script 02_Linguistic_A
# Get Sentix AffectWordNet (from GET_SAWN)

library(tidyverse)

stopwords <- tibble(lemma = c("essere","avere","fare","dovere",
                              "potere","volere", "anche", 
                              "come", "quando", "dove",
                              "ovunque", "dovunque", "chiunque",                               "perché", "poiché", "affinché",
                              "dopodiche", "quanto","su", "giù",                               "ora", "appena"))

vax_clean <-vax_ling %>%
  select(c(doc_id, token_id, date, token, lemma, pos = upos, 
           hashtags, favourites_count,followers_count, 
           retweet_count, statuses_count, quote_count, verified,
           reply_count, txt_original, screen_name)) %>%  
  mutate(lemma = tolower(lemma),
         lemma = str_remove_all(lemma, "^\\>+")) %>% 
  filter(pos %in% c("NOUN","VERB","ADV","ADJ")) %>% 
  mutate(lemma = str_replace_all(lemma, "vaccio", "vaccino"), # replace a bad udpipe lemmatization of "vaccino"
         pos = ifelse(lemma == "vaccino", "NOUN", pos),
         pos = str_replace_all(pos, "NOUN", "n"),
         pos = str_replace_all(pos, "VERB", "v"),
         pos = str_replace_all(pos, "ADV", "r"),
         pos = str_replace_all(pos, "ADJ", "a")) %>%
  filter(nchar(lemma) > 1) %>% # get rid of nchar <= 1 words
  anti_join(stopwords)

# dataset of negators for next re-adding step
vax_clean_negators <- vax_clean %>% 
  filter(pos == "NEGATOR")

# Polarity scoring for each token
sent_words <- vax_clean %>%
  inner_join(S_AWN, by = c("lemma", "pos")) %>% 
  add_row(vax_clean_negators) %>% # re-adding not scored negators
  arrange(doc_id, token_id) %>%
  group_by(pos) %>% 
  mutate(polarity = ifelse(is.na(polarity) & pos == "NEGATOR",
                           -1.5, polarity)) %>% # scoring negators
  ungroup()

# Sentiment by tweets: sum of scores of single words per each tweet
sent_tweets <- sent_words %>%
  group_by(doc_id, date) %>% 
  summarise_at(.vars = c("polarity"), sum) %>%
  ungroup()

# Sentiment by day: sum of tweets score
# 2021-03-16 has a very negative score and can be considered an outlier
# I have adjusted this value to -2.2 (0.2 point under the lowest value)
sent_day <- sent_tweets %>% 
  group_by(date) %>% 
  summarise(polarity = sum(polarity)) %>% 
  mutate(polarity = scale(polarity)) %>% 
  ungroup() %>% 
  mutate(polarity = replace(polarity,
                            date == "2021-03-16", -2.2)) %>% 
  mutate(polarity = round(polarity, digits = 3))

# CHARTS

# daily trendline's sum of tweets
s_day %>% 
  ggplot(aes(x =  date, y = polarity, fill = polarity)) +
  geom_col(na.rm = TRUE, position = position_identity()) +
  geom_hline(yintercept = .0, linetype = "dashed", color = 
               "dodgerblue3") +
  stat_smooth(se = FALSE, color = "hotpink2") +
  theme_bw() +
  xlab(NULL) +
  ylab("Polarity") +
  labs(title = "Graph 1 - Polarity of all Tweets per day") +
  scale_y_continuous(breaks=function(x) seq(from = -2.2, to = 1.2, by = 0.3),
                     label = scales::label_number_auto()) +
  labs(title = "Distribution of Daily's Polarity of all Tweets",
       caption = paste0(length(s_tweets$polarity),
                        " scored sentiment tweets over a total of ",
                        length(vax_base$doc_id)," (",
                        round(length(s_tweets$polarity)/length(vax_base$doc_id)*100,
                              digits = 1), "%) ")) +
  scale_x_date(breaks = function(x) seq.Date(from = min(x), to = max(x), by = 5),
               date_labels = "%b-%d") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
