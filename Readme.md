### ** under construction **

### for English version[see here]:

# Project 1: A proposito del vaccino anti-COVID19 in Italia: umori e linguaggio.
## *Analisi testuale e del sentiment lexicon-based su un campione di tweets.*

# Project Overview

- Estratto, tramite l'API di Twitter, un corpus di circa 65.000 tweets in linuga italiana, nell'arco di due mesi, da metà Marzo 2021 a metà Maggio 2021, coincidenti con il periodo di maggior discussione del tema nell'opinione pubblica.
Query su hashtags legati al vaccino anticovid nonché alle due principali case farmaceutiche produttrici: Pfizer e AstraZeneca. Estrazione senza retweets.
- Creata una lookup table in formato csv con il lessico polarizzato per la lingua italiana, adattato dal Sentix (Basile e Nissim, 2013) a cui è stata aggiunta la classificazione e la gerarchia della semantica affettiva di WordnetAffect (Strapparava e Valitutti, 2004, 2006).
L'obiettivo è la creazione uno strumento unico e agile per l'analisi del sentiment e del linguaggio affettivo in lingua italiana,
utilizzabile nel text mining non supervisionato di tipo *lexicon based*.
- Analisi linguistica dei tweets: frequenze, misure lessicometriche, parti del discorso, n-grams, key-words, co-occorrenze, concordanze.
- Analisi di: Sentiment, Emoticons, Linguaggio Affettivo, Topics.
- Questo progetto è preliminare al secondo: creazione di un modello di classificazione e un labelled training database (NEG vs POS)
per la Sentiment Analisi dei tweets in relazione al tema dei vaccini.

# Codice e risorse

R 4.0.4 e RStudio 1.4.1103.
Packages: rtweet, tidyverse, rvest, udpipe, topicmodels, wordcloud2.

- Per la creazione del lessico:
  1. [Sentix, di Basile e Nissim (2013)](http://valeriobasile.github.io/twita/sentix.html);
  2. [WordNetAffect, di Strapparava e Valitutti, 2004, 2006](https://wndomains.fbk.eu/wnaffect.html) Utilizzata la versione WNA 1.1 con synsets-offsets WordNet (v 3.0).
- Per la feature extraction: il language model italiano, basato sulle Universal Dependencies (CoNLL-U format), addestrato su un corpus di tweets:
  [UD Italian PoSTWITA vers. 2.5 di Bosco e Sanguinetti (2018)](https://universaldependencies.org/treebanks/it_postwita/index.html)
- Per l'individuazione delle espressioni polirematiche: La digital library [IntraText](http://www.intratext.com/)
- Per il sentiment delle emojis: [Emoji Sentiment Ranking v 1.0, di Kralj Novak, Smailovic, Sluban, Mozetic, 2015](http://kt.ijs.si/data/Emoji_sentiment_ranking/index.html)
- Per lo scraping delle icone emojis nel grafico ho adattato il seguente script di: [Emil Hvitfeldt](https://www.hvitfeldt.me/blog/real-emojis-in-ggplot2/)

# Preprocessing e Features Extraction

1. Cleaning dei tweets: rimozione delle peculiarità dei tweets, come urls, simboli, caratteri non codificati utf-8.
2. Estrazione delle Features: Tokenizzazione, Lemmatizzazione e POS Tagging.
3. Riduzione delle Features: rimozione delle parti del discorso prive di valenza semantica, mantenendo solo: nomi, aggettivi, verbi, avverbi e i negatori.

## References e Licenze

Sia per le licenze delle risorse utilizzate che per i rispettivi riferimenti in letteratura, si vedano le relative repositories sopra linkate.

- 
-
-

## [1 - Analisi linguistiche]()

## [2 - Analisi del sentiment e delle emozioni]()



# Project 2: Sentiment dei discorsi sul vaccino anti-COVID19 in Italia: modelli di classificazione dei tweets. 

## *under construction*
