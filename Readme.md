### ** under construction **

### for English version[see here]:

# Project 1: A proposito del vaccino anti-COVID19 in Italia: umori e linguaggio.
## *Analisi testuale e del sentiment lexicon-based su un campione di tweets.*

## **Project Overview**

- Estratto, tramite l'API di Twitter, un corpus di circa 65.000 tweets in linuga italiana, nell'arco di due mesi, dal 15 Marzo 2021 al 16 Maggio 2021, coincidenti con il periodo di maggior discussione del tema "vaccini anticovid" nell'opinione pubblica.
- Creata una lookup table in formato csv con il lessico polarizzato per la lingua italiana, adattato dal Sentix (Basile e Nissim, 2013) a cui è stata aggiunta la classificazione e la gerarchia della semantica affettiva di WordnetAffect (Strapparava e Valitutti, 2004, 2006).
L'obiettivo è la creazione uno strumento unico e agile per l'analisi del sentiment e del linguaggio affettivo in lingua italiana,
utilizzabile nel text mining non supervisionato di tipo *lexicon based*.
- Analisi linguistica dei tweets: frequenze, misure lessicometriche, parti del discorso, n-grams, key-words, co-occorrenze, concordanze.
- Analisi di: Sentiment, Emoticons, Linguaggio Affettivo, Topics.
- Questo progetto è preliminare al secondo: creazione di un modello di classificazione e un labelled training database (NEG vs POS)
per la Sentiment Analisi dei tweets in relazione al tema dei vaccini.

### **Codice e risorse**

Last R and RStudio versions.
Main Packages: rtweet, tidyverse, rvest, udpipe.

- Per la creazione del lessico: [OpeNER Sentiment Lexicon Italian](http://hdl.handle.net/20.500.11752/ILC-73) di: Russo, Irene; Frontini, Francesca and Quochi, Valeria, 2016, OpeNER Sentiment Lexicon Italian - LMF, ILC-CNR for CLARIN-IT repository hosted at Institute for Computational Linguistics "A. Zampolli", National Research Council, in Pisa, 

- Per la feature extraction: il language model italiano, basato sulle Universal Dependencies (CoNLL-U format), addestrato su un corpus di tweets:
  [UD Italian PoSTWITA vers. 2.5 di Bosco e Sanguinetti (2018)](https://universaldependencies.org/treebanks/it_postwita/index.html)
- Per il sentiment delle emojis: [Emoji Sentiment Ranking v 1.0, di Kralj Novak, Smailovic, Sluban, Mozetic, 2015](http://kt.ijs.si/data/Emoji_sentiment_ranking/index.html)
- Per lo scraping delle icone emojis nel grafico ho adattato il seguente script di: [Emil Hvitfeldt](https://www.hvitfeldt.me/blog/real-emojis-in-ggplot2/)


### **References e Licenze**

Sia per le licenze delle risorse utilizzate che per i rispettivi riferimenti in letteratura, si vedano le relative repositories sopra linkate.

- Zaga, Cristina. (2012). TWITTER: UN’ANALISI DELL’ITALIANO NEL MICRO BLOGGING. Italiano LinguaDue. 4. 10.13130/2037-3597/2278. [Link](https://www.researchgate.net/publication/307707857_TWITTER_UN%27ANALISI_DELL%27ITALIANO_NEL_MICRO_BLOGGING)
- Cimino, Andrea & Cresci, Stefano & Dell'Orletta, Felice & Tesconi, Maurizio. (2014). Linguistically–motivated and Lexicon Features for Sentiment Analysis of Italian Tweets. 10.12871/clicit2014214 [Link](https://www.researchgate.net/publication/272480560_Linguistically-motivated_and_Lexicon_Features_for_Sentiment_Analysis_of_Italian_Tweets)
- Musto, Cataldo & Semeraro, Giovanni & Polignano, Marco. (2014). A comparison of lexicon-based approaches for sentiment analysis of microblog. CEUR Workshop Proceedings. 1314. 59-68.
[Link](https://www.researchgate.net/publication/287871786_A_comparison_of_lexicon-based_approaches_for_sentiment_analysis_of_microblog)
- ... under construction

## [Analisi del Sentiment](https://github.com/Gabmi73/Covid_Language/blob/master/Analysis.md)

# Project 2: Sentiment dei discorsi sul vaccino anti-COVID19 in Italia: modelli di classificazione dei tweets.*under construction*

