library(tidyverse)

# Sentix-AffectWordNet is the result from mapping:
# 1) Sentix 
#    http://valeriobasile.github.io/twita/sentix.html
# 2) WordNet Affect 1.1
#    https://wndomains.fbk.eu/wnaffect.html
#    both files of synsets and categorization heierachy are also available at
#    https://github.com/orthoressyco/WNAffect/tree/master/src/main/resources

sentix <- "http://valeriobasile.github.io/twita/sentix.gz"
affect <- "https://raw.githubusercontent.com/orthoressyco/WNAffect/master/src/main/resources/a-synsets-30.xml"
category <- "https://raw.githubusercontent.com/orthoressyco/WNAffect/master/src/main/resources/a-hierarchy.xml"

SAWN_create <- function(s, a, c) {
  require(xml2)
  require(data.table)
  
  ## 1) Sentix
  sx <- data.table::fread(s, colClasses = c(V3 = "character"),
                          encoding = "UTF-8") %>% 
    rename(lemma = V1, pos = V2, synset = V3, pos_WN = V4,
           neg_WN = V5, polarity = V6, intensity = V7) %>%
    mutate(polarity = round(polarity,3),
           intensity = round(intensity,3),
           lemma = tolower(lemma))
  
  ## 2) AffectWordNet
  syn_n <- bind_rows(syn_aff = xml_attr(xml_find_all(read_xml(a), ".//noun-syn"), "id"),
                     word = xml_attr(xml_find_all(read_xml(a), ".//noun-syn"), "categ")) %>% 
           mutate(syn_aff = str_remove_all(syn_aff, "[:alpha:]#"))        
  
  syn_d <- bind_rows(syn_aff = c(xml_attr(xml_find_all(read_xml(a), ".//adj-syn"), "noun-id"),
                                 xml_attr(xml_find_all(read_xml(a), ".//verb-syn"), "noun-id"),
                                 xml_attr(xml_find_all(read_xml(a), ".//adv-syn"), "noun-id")),
                     synset = c(xml_attr(xml_find_all(read_xml(a), ".//adj-syn"), "id"),
                                xml_attr(xml_find_all(read_xml(a), ".//verb-syn"), "id"),
                                xml_attr(xml_find_all(read_xml(a), ".//adv-syn"), "id"))) %>%
           mutate(syn_aff = str_remove_all(syn_aff, "[:alpha:]#"),
                  synset = str_remove_all(synset, "[:alpha:]#"))
  
  cat <- bind_rows(word = xml_attr(xml_find_all(read_xml(c), ".//categ"), "name"),
                   category = xml_attr(xml_find_all(read_xml(c), ".//categ"), "isa"))
  
  # merging synsets and categorization
  awn <- syn_n %>% 
    left_join(syn_d) %>% 
    left_join(cat) %>% 
    mutate(synset = ifelse(is.na(synset), syn_aff, synset)) %>% 
    select(-syn_aff)
  
  # merging AffectWordNet with sentix            
  all <- sx %>% 
    left_join(awn) %>% 
    tibble()
}

# Get lookup table
# some cleaning: get rid of full rows duplicated, keeping only unigrams
# to reduce polipathy: select all non duplicated by lemma
# choose of the most intense associated value of a word

S_AWN <- SAWN_create (sentix, affect, category) %>% 
  distinct() %>% 
  filter(!str_detect(lemma, "[:punct:]")) %>% 
  group_by(lemma) %>%
  distinct(pos, polarity, intensity, word, category) %>% 
  filter(intensity == max(intensity)) %>% 
  ungroup()
