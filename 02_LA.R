# Linguistic analysis
# Get vax_base from script 01_Vax_Base 

library(tidyverse)
library(udpipe)
# udpipe_download_model(language = "italian-postwita")
udmodel_ita <- udpipe_load_model(file = './italian-postwita-ud-2.5-191206.udpipe')

# FEATURE EXTRACTION

# Words annotations: it takes a very long time, depending on the number of tweets.
udpipe_c <- vax_base$text %>%
  udpipe_annotate(object = udmodel_ita,
                  parser = "none",
                  trace = TRUE)

# Another little bit of time for transforming as data.frame...
udpipe_df <- as.data.frame(udpipe_c) %>% 
  mutate(doc_id = as.numeric(
    str_replace_all(doc_id, "[:alpha:]", "")))

# New table vax_ling
vax_ling <- udpipe_df %>%
  group_by(doc_id) %>% 
  left_join(vax_base) %>% 
  select(-c("paragraph_id", "head_token_id", "feats",
            "sentence", "sentence_id","deps", "misc",
            "dep_rel")) %>%
  ungroup() %>% 
  mutate(
    upos = ifelse(
        lemma == "non"|lemma == "mai"|lemma == "senza"|
        lemma == "no" | lemma == "neanche" | lemma == "neppure"|
        lemma == "nemmeno", "NEGATOR", upos))
                          # tagging most common italian' negators into a new
                          # category called "NEGATOR"


# Cleaning
stopwords <- tibble(lemma = c("essere","avere","fare","dovere", "potere","volere", "anche", 
                              "come", "quando", "dove", "ovunque", "dovunque", "chiunque",
                              "perché", "poiché", "affinché", "dopodiche", "quanto","su",
                              "giù", "ora", "appena", "già", "più", "vaccino", "vaccinazione",
                              "vaccini","vaccinare", "vaccinato", "ancora", "oggi", "ieri",
                              "casi", "caso", "nuovo"))

vax_clean <-vax_ling %>%
  select(c(doc_id, token_id, date, token, lemma, pos = upos, 
           hashtags, favourites_count, followers_count, 
           retweet_count, statuses_count, quote_count, verified,
           reply_count, txt_original, screen_name)) %>%  
  mutate(lemma = tolower(lemma),
         lemma = str_remove_all(lemma, "^\\>+")) %>% 
  filter(pos %in% c("NOUN","VERB","ADV","ADJ", "NEGATOR")) %>% 
  mutate(lemma = str_replace_all(lemma, "vaccio", "vaccino"), # replace a bad udpipe lemmatization of "vaccino"
         pos = ifelse(lemma == "vaccino", "NOUN", pos)) %>%
  filter(nchar(lemma) > 1) %>% # get rid of nchar <= 1 words
  anti_join(stopwords)


# POS ANALYSIS

pos <- vax_ling %>%
  filter(!is.na(lemma)) %>%
  mutate(lemma = tolower(lemma)) %>%
  group_by(upos) %>% 
  count(sort = TRUE) %>% 
  ungroup() %>% 
  mutate(percent = round(n/sum(n)*100, digits = 2))

plot_pos <- pos %>%
  ggplot(aes(x = reorder(upos, -percent), y = percent, fill = upos)) +
  geom_bar(stat = "identity") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1,
                                   colour = ifelse(pos$upos == "NOUN" | pos$upos == "VERB" | pos$upos =="ADJ" | pos$upos == "ADV", "red", "blue")),
        axis.line = element_blank(),
        axis.ticks.x.bottom = element_blank(),
        legend.title = element_blank(),
        legend.position = "none") +
  viridis::scale_fill_viridis(discrete = TRUE) +
  ylab("Frequency %")+
  xlab(NULL) +
  labs(title = "Fig 1 -   POS: Part Of Speech Tagging",
       subtitle = "Red coloured the four semantic Pos: Nouns, Verbs, Adjectives and Adverbs")
  
ggsave(filename = "PartOfSpeech.png",
       path = "./images",
       plot = plot_pos,
       width = 17,
       height = 12,
       units = "cm",
       dpi = 300)

