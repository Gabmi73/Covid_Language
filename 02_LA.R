# Linguistic analysis
# Get vax_base from script 01_Vax_Base

library(tidyverse)
library(udpipe)
# udpipe_download_model(language = "italian-postwita")
umodel_ita <- udpipe_load_model(file = './italian-postwita-ud-2.5-191206.udpipe')

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

# POS ANALYSIS

pos <- vax_ling %>%
  filter(!is.na(lemma)) %>%
  mutate(lemma = tolower(lemma)) %>%
  group_by(upos) %>% 
  count(sort = TRUE) %>% 
  ungroup() %>% 
  mutate(percent = round(n/sum(n)*100, digits = 2))
