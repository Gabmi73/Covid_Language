### *STATISTICHE*
Query sui seguenti hashtags: #vaccinoCovid OR #VaccinoAntiCovid OR #vaccino OR #PfizerVaccine OR #AstraZeneca. Estrazione senza retweets.
![tab1](/images/Descritpives_01.png)
Le seguenti statistiche lessicali sono comprendono gli indici della ricchezza del vocabolario, poiché affetti da distorsioni dovuti all'altissimo numero delle occorrenze.
![tab2](/images/Lexicomentry_02.png)
Basandosi solo sulle frequenze del corpus pulito, si può apprezzare, con le dovute cautele, un vocabolario con un discreto livello di ricchezza lessicale: a fronte di una riduzione del 60% dei tokens, rispetto al testo originale intero, i types sono scesi poco meno del 13%.

Il Grafico 1 mostra la frequenza delle parti del discorso denotando un elevato numero di nomi e verbi mentre più contenute sono le altre POS relative ai termini semanticamente significativi, in particolare gli aggettivi. Per un confronto sull'uso dell'italiano nel microblogging, si rimanda a Zaga(2012)

![fig1](/images/01_PartOfSpeech.png)


### *PREPROCESSING ED ESTRAZIONE DELLE FEATURES*

1. Cleaning dei tweets: rimozione delle peculiarità grafiche dei tweets: urls, simboli, caratteri non ASCII.

2. Estrazione delle Features: Tokenizzazione, Lemmatizzazione e POS Tagging. Il match con il dizionario OpeNER Sentiment Lexicon Italian (ISL) è stato fatto sui lemmi. Per le annotazioni ho utilizzato il modello italiano UDPIPE italian-postwita-ud-2.5-191206, escludendo il parsing morfo-sintattico.

3. Creazione di una categoria separata "NEGATOR" comprendente i più comuni e frequenti termini negativizzanti: "non, no, mai, senza, neppure, neache, nemmeno".

4. Riduzione delle Features: rimozione delle parti del discorso prive di valenza semantica, mantenendo solo: nomi, aggettivi, verbi, avverbi e i negatori. Rimossi inoltri alcuni avverbi di uso molto frequente e poco significiativi. (es. ora, più, adesso ecc.)

5. GESTIONE DI NEGATORI E POLISEMIA

    L'approccio metodologico lexicon-based non consente una gestione puntuale dei termini positivi, o negativi, la cui polarità viene ribaltata quando preceduti dal negatore (es. "bello vs non bello, brutto vs non brutto" ecc). Il lessico ISL inoltre non li contiene; per mantenere un computo complessivo del sentiment quanto più possibile prossimo al valore effettivo, seppur con i limiti del caso, ho deciso di attribuire il punteggio -1 agli avverbi, preposizioni e congiunzioni della lista "NEGATOR". Alquanto complessa e senza sostanziali differenze la gestione dei negatori che ho testato tramite analisi degli *n*-grams.

    Il totale dei negatori rappresenta comunque una minima parte del vocabolario, pari a n 29115/581001 (ovvero solo il 5% dei token nel corpus cleaned)

    Ho rinunciato alla gestione della polisemia e della sua disambiguazione in quanto troppo complessa e con risultati dubbi per questa metodologia.


### *ANALISI DEL SENTIMENT*

Il sentiment (fig. 2) si distribuisce normalmente ma appare più polarizzato al negativo anche se il suo valore trend non è marcatamente negativo. Si nota tuttavia un andamento lievemente positivo nelle due settimane finali di aprile, circa dal 18 al 30.
Spiccano almento due gruppi di giorni con i più alti picchi di sentiment sia negativi che positivi.



![fig2](/images/02_sentiment.png)


![fig3](/images/03_tw_day.png)

Visualizziamo nel dettaglio i due gruppi e un giorno singolo in base al sentiment e le parole che sono maggiormente caratteristiche, tentando, tramite lo scoring Tf-Idf, una loro tematizzazione (non ho analizzato il Topic Modeling perché la natura dei tweets è già di per sé suddivisa in argomenti, tramite gli hashtags. Inoltre mi interessano le parole più caratteristiche di ogni giorno):

- Gruppo 1) dal 15 al 17 marzo. Polarizzazione marcatamente negativa. Si registra un' alta percentuale di numero di parole del corpus 18,13 % (il 16 marzo è il giorno con il numero assoluto più alto dell'intero corpus: 11,64 %)

![w1](/images/Words_g1.png)

- Gruppo 2) dal 18 al 20 marzo. Polarizzazione marcatemente positiva. Anche in questo gruppo la percentuale totale delle parole è 11,98 %

![w2](/images/Words_g2.png)

- 07 aprile. Polarizzazione marcatamente negativa. Percentuale parole 4,71 %.

![w4](/images/Words_0704.png)

Di seguito invece la wordcloud delle parole più frequenti dell'intero corpus e di quelle, sempre più frequenti, dei due poli del seintiment, positivo e negativo

![wc1](/images/WC_Twitter.jpg)


![wc2](/images/POS.png)
![wc3](/images/NEG_.png)




![fig4](/images/04_top50_emojis.png)


... under construction




