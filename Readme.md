# A proposito del vaccino anti-COVID19 in Italia: umori e linguaggio.
## *Analisi testuale e del sentiment lexicon-based su un campione di tweets.* - Uno studio preliminare

## **Project Overview**

- Estratto, tramite l'API di Twitter, un corpus di circa 65.000 tweets in linuga italiana, nell'arco di due mesi, dal 15 Marzo 2021 al 16 Maggio 2021, coincidenti con il periodo periodo di maggior discussione sul tema "vaccini anticovid" nell'opinione pubblica.
- Analisi linguistica dei tweets: frequenze, misure lessicometriche, parti del discorso e wordcloud.
- Analisi del sentiment polarizzato positivo vs negativo e del sentiment delle Emojis.
- Questo progetto è anche preliminare ai modelli di Machine e Deep Learning del secondo: creazione di un databese sia labelled (NEG vs POS training/test) sia unlabelled per le predictions di altri modelli.

### **Codice e risorse**

- R 4.1.1 and RStudio 2021.09.0 Build 351. Main Packages: rtweet, tidyverse, rvest, udpipe.
- Python 3.8.11. Linguistic analysis with Spacy

- Per la creazione del lessico: [OpeNER Sentiment Lexicon Italian](http://hdl.handle.net/20.500.11752/ILC-73) di: Russo, Irene; Frontini, Francesca and Quochi, Valeria, 2016, OpeNER Sentiment Lexicon Italian - LMF, ILC-CNR for CLARIN-IT repository hosted at Institute for Computational Linguistics "A. Zampolli", National Research Council, in Pisa, 
- Per la feature extraction: il language model italiano, basato sulle Universal Dependencies (CoNLL-U format), addestrato su un corpus di tweets:
  [UD Italian PoSTWITA vers. 2.5 di Bosco e Sanguinetti (2018)](https://universaldependencies.org/treebanks/it_postwita/index.html)
- Per il sentiment delle emojis: [Emoji Sentiment Ranking v 1.0, di Kralj Novak, Smailovic, Sluban, Mozetic, 2015](http://kt.ijs.si/data/Emoji_sentiment_ranking/index.html)
- Per lo scraping delle icone emojis nel grafico ho adattato il seguente script di: [Emil Hvitfeldt](https://www.hvitfeldt.me/blog/real-emojis-in-ggplot2/)

### **References e Licenze**

Sia per le licenze delle risorse utilizzate che per i rispettivi riferimenti in letteratura, si vedano le relative repositories sopra linkate.

- Zaga, Cristina. (2012). TWITTER: UN’ANALISI DELL’ITALIANO NEL MICRO BLOGGING. Italiano LinguaDue. 4. 10.13130/2037-3597/2278. [Link](https://www.researchgate.net/publication/307707857_TWITTER_UN%27ANALISI_DELL%27ITALIANO_NEL_MICRO_BLOGGING)
- Cimino, Andrea & Cresci, Stefano & Dell'Orletta, Felice & Tesconi, Maurizio. (2014). Linguistically–motivated and Lexicon Features for Sentiment Analysis of Italian Tweets. 10.12871/clicit2014214 [Link](https://www.researchgate.net/publication/272480560_Linguistically-motivated_and_Lexicon_Features_for_Sentiment_Analysis_of_Italian_Tweets)
- Musto, Cataldo & Semeraro, Giovanni & Polignano, Marco. (2014). A comparison of lexicon-based approaches for sentiment analysis of microblog. CEUR Workshop Proceedings. 1314. 59-68. [Link](https://www.researchgate.net/publication/287871786_A_comparison_of_lexicon-based_approaches_for_sentiment_analysis_of_microblog)

# [Analisi del Sentiment](https://github.com/Gabmi73/Covid_Language/blob/master/Sent_Analysis.md)

