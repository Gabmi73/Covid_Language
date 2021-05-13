library(tidyverse)

# ALI AffectLexiconItalian, result from mapping:
# 1) Sentix 
#    http://valeriobasile.github.io/twita/sentix.html
# 2) WordNet Affect 1.1
#    https://wndomains.fbk.eu/wnaffect.html

# to get 2) download local in your path

sentix_url <- "http://valeriobasile.github.io/twita/sentix.gz"
wna_file <- "./wn-affect-1.1/a-synsets-30.xml"
hier_file <- "./wn-affect-1.1/a-hierarchy.xml"

ALI_Create <- function(sentix, wna, hier) {
  require(xml2)
  require(data.table)
  
  ## 1) Sentix scrape and renaming
  sentix <- data.table::fread(sentix, colClasses = c(V3 = "character"),
                              encoding = "UTF-8") %>% 
    rename(lemma = V1, pos = V2, synset = V3, pos_WN = V4,
           neg_WN = V5, polarity = V6, intensity = V7) %>%
    mutate(polarity = round(polarity,3),
           intensity = round(intensity,3),
           lemma = tolower(lemma))
  
  ## 2) Parsing WNA synsets
  affect <- bind_rows(synset = c(xml_attr(xml_find_all(read_xml(wna), ".//noun-syn"), "id"),
                                 xml_attr(xml_find_all(read_xml(wna), ".//adj-syn"), "id"),
                                 xml_attr(xml_find_all(read_xml(wna), ".//verb-syn"), "id"),
                                 xml_attr(xml_find_all(read_xml(wna), ".//adv-syn"), "id")),
                      affect = c(xml_attr(xml_find_all(read_xml(wna), ".//noun-syn"), "categ"),
                                 xml_attr(xml_find_all(read_xml(wna), ".//adj-syn"), "categ"),
                                 xml_attr(xml_find_all(read_xml(wna), ".//verb-syn"), "categ"),
                                 xml_attr(xml_find_all(read_xml(wna), ".//adv-syn"), "categ"))) %>% 
    mutate(synset = str_remove_all(synset, "[:alpha:]#"))
  
  ## 3) Parsing WNA Hierarchy
  hierarchy <- bind_rows(
    affect = xml_attr(xml_find_all(read_xml(hier), ".//categ"), "name"),
    category = xml_attr(xml_find_all(read_xml(hier), ".//categ"), "isa"))
  
  ah <- affect %>% left_join(hierarchy)                      
  
  ALI <- sentix %>% 
    left_join(ah) %>% 
    tibble()
}

ALI <- ALI_Create(sentix_url, wna_file, hier_file) %>%
  distinct() %>% 
  group_by(lemma) %>% 
  distinct(pos, polarity, intensity, affect, category) %>% 
  filter(intensity == max(intensity)) %>% 
  ungroup()


remove("sentix_url", "wna_file", "hier_file", "ALI_Create")
