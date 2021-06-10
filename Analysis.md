### *STATISTICHE*
Query sui seguenti hashtags: #vaccinoCovid OR #VaccinoAntiCovid OR #vaccino OR #PfizerVaccine OR #AstraZeneca. Estrazione senza retweets.
![tab1](/images/Descritpives_01.png)
Per le statistiche lessicali sono state tralasciate le analisi della ricchezza del vocabolario, poiché affette da distorsioni dovute all'altissimo numero delle occorrenze.
![tab2](/images/Lexicomentry_02.png)
Basandosi solo sulle frequenze del corpus pulito, si può apprezzare, con le dovute cautele, un vocabolario con un discreto livello di ricchezza lessicale: a fronte di una riduzione del 60% dei tokens, rispetto al testo originale intero, i types sono scesi poco meno del 13%.

Il Grafico 1 mostra la frequenza delle parti del discorso denotando un elevato numero di nomi e verbi mentre più contenute sono le altre POS relative ai termini semanticamente significativi, in particolare gli aggettivi. Per un confronto sull'uso dell'italiano nel microblogging, si rimanda a Zaga(2012)

![fig1](/images/01_PartOfSpeech.png)


### *PREPROCESSING ED ESTRAZIONE DELLE FEATURES*

1. Cleaning dei tweets: rimozione delle peculiarità grafiche dei tweets: urls, simboli, caratteri non ASCII.

2. Estrazione delle Features: Tokenizzazione, Lemmatizzazione e POS Tagging. Il match con il dizionario OpeNER Sentiment Lexicon Italian (ISL) è stato fatto sui lemmi. Per le annotazioni ho utilizzato il modello italiano UDPIPE italian-postwita-ud-2.5-191206, escludendo il parsing morfo-sintattico.

3. Creazione di una categoria separata "NEGATOR" comprendente i più comuni e frequenti termini negativizzanti: "non, no, mai, senza, neppure, neache, nemmeno".

4. Riduzione delle Features: rimozione delle parti del discorso prive di valenza semantica, mantenendo solo: nomi, aggettivi, verbi, avverbi e i negatori.

5. GESTIONE DI NEGATORI, POLISEMIA E TF-IDF

    L'approccio lexicon-based non consente una gestione puntuale dei termini positivi, o negativi, la cui polarità viene ribaltata quando preceduti dal negatore (es. "bello vs non bello, brutto vs non brutto" ecc). Il lessico ISL inoltre non li contiene; per mantenere un computo complessivo del sentiment, quantomeno più prossimo al valore reale, seppur con i limiti del caso, ho deciso di attribuire il punteggio -1 ai seguenti avverbi, preposizioni e congiunzioni più comuni: non, no, mai, senza, neanche, neppure, nemmeno. Alquanto complessa e senza sostanziali differenze la gestione dei negatori che ho testato tramite analisi dei bigrammi, in alcuni casi anche trigrammi.

    Il totale dei negatori rappresenta comunque una minima parte del vocabolario, pari a n 29115/581001 (ovvero solo il 5% dei token nel corpus cleaned)

    Ho rinunciato alla questione della polisemia e della sua disambiguazione in quanto al limite dell'impossibile per questa metodologia.

    Ho valutato inoltre non utile l'estrazione ed analisi dei termini peculiari con TF-IDF: innanzitutto manca un raggruppamento dotato di senso dei tweets, che quindi vengono considerati come singoli documenti. La matrice termini-per-documenti(oltre 64.000) non ha molto senso. Inoltre la stragrande maggioranza dei termini a bassa/unica frequenza sono errori di digitazione.



### *ANALISI DEL SENTIMENT*

.. under construction

![fig2](/images/02_sentiment.png)


![fig3](/images/03_tw_day.png)


![fig4](/images/04_top50_emojis.png)


![wc1](/images/WC_Twitter.jpg)


![wc2](/images/POS.png)
![wc3](/images/NEG_.png)


... under construction




