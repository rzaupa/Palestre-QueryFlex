    drop table if exists Cliente_Corso;
    drop table if exists Esercizio_Scheda;
    drop table if exists Esercizio_gruppomuscolare;
    drop table if exists Corso;
    drop table if exists Scheda;
    drop table if exists Esercizio;
    drop table if exists Istruttore;
    drop table if exists Areafitness;
    drop table if exists Iscrizione;
    drop table if exists ListinoPrezzi;
    drop table if exists Cliente;
    drop table if exists Palestra;
    drop table if exists GruppoMuscolare;
    drop type if exists genere;

    CREATE TYPE genere AS ENUM('M', 'F');

    --Table Palestra-------------------------
    CREATE TABLE Palestra
    (
        Citta varchar(50),
        Indirizzo varchar(50),
        AperturaFeriali time NOT NULL,
        ChiusuraFeriali time NOT NULL,
        AperturaFestivi time NOT NULL,
        ChiusuraFestivi time NOT NULL,
        PRIMARY KEY (Citta,Indirizzo)
    );


    -- Table Cliente --------------------------
    CREATE TABLE Cliente
    (
        Cf varchar(16) PRIMARY KEY,
        Nome varchar(20) NOT NULL,
        Cognome varchar(20) NOT NULL,
        Mail varchar(50) NOT NULL,
        DataNascita date NOT NULL,
        Sesso genere NOT NULL
    );


    -- Table Istruttore --------------------------
    CREATE TABLE Istruttore
    (
        Cf varchar(16) PRIMARY KEY,
        Nome varchar(20) NOT NULL,
        Cognome varchar(20) NOT NULL,
        DataNascita date NOT NULL,
        Sesso genere NOT NULL,
        CittaPalestra varchar(50) NOT NULL,
        IndirizzoPalestra varchar(50) NOT NULL,
        FOREIGN KEY (CittaPalestra,IndirizzoPalestra) REFERENCES Palestra(Citta,Indirizzo) on update cascade on delete cascade
    );

    -- Table ListinoPrezzi--------------------------
    CREATE TABLE ListinoPrezzi
    (
        Id serial PRIMARY KEY,
        PrezzoAreaFitnessMensile real NOT NULL,
        PrezzoIscrizione real NOT NULL
    );

    -- Table Areafitness------------------------------
    CREATE TABLE Areafitness
    (
        Id serial PRIMARY KEY,
        DataInizio date NOT NULL,
        DataFine date NOT NULL,
        Listino integer NOT NULL,
        Prezzo real,
        Cliente varchar(16) NOT NULL,
        FOREIGN KEY (cliente) REFERENCES Cliente (Cf) on update cascade on delete cascade,
        FOREIGN KEY (listino) REFERENCES ListinoPrezzi (id) on update cascade on delete cascade,
        check (DataInizio<DataFine)
    );


    -- Table Scheda --------------------------
    CREATE TABLE Scheda
    (
        Id SERIAL PRIMARY KEY,
        Areafitness integer NOT NULL,
        DataInizio date NOT NULL,
        DataFine date NOT NULL,
        Istruttore varchar(16) NOT NULL,
        FOREIGN KEY (Areafitness) REFERENCES Areafitness (Id) on update cascade on delete cascade,
        FOREIGN KEY (Istruttore) REFERENCES Istruttore (Cf) on update cascade,
        check (DataInizio<DataFine)
    );


    -- Table Esercizio --------------------------
    CREATE TABLE Esercizio
    (
        Nome varchar(50) PRIMARY KEY,
        Descrizione varchar(200) NOT NULL
    );


    -- Table GruppoMuscolare --------------------------
    CREATE TABLE GruppoMuscolare
    (
        Nome varchar(20) PRIMARY KEY,
        Categoria varchar(20)
    );


    -- Table Corso --------------------------
    CREATE TABLE Corso
    (
        Nome varchar(50),
        Edizione int,
        CittaPalestra varchar(50) NOT NULL,
        IndirizzoPalestra varchar(50) NOT NULL,
        Descrizione varchar(150) NOT NULL,
        Orario varchar(50) NOT NULL,
        Istruttore varchar(16) NOT NULL,
        DataInizio date NOT NULL,
        DataFine date,
        Prezzo real NOT NULL,
        NumeroMaxPartecipanti int NOT NULL,
        PRIMARY KEY(Nome,Edizione,CittaPalestra,IndirizzoPalestra),
        FOREIGN KEY (Istruttore) REFERENCES Istruttore (Cf) on update cascade,
        FOREIGN KEY (CittaPalestra,IndirizzoPalestra) REFERENCES Palestra(Citta,Indirizzo) on update cascade on delete cascade,
        check (dataInizio<DataFine)
    );


    -- Table Cliente_Corso-----------------------------
    CREATE TABLE Cliente_Corso
    (
        Cliente varchar(16),
        NomeCorso varchar(50),
        EdizioneCorso int,
        CittaPalestraCorso varchar(50) NOT NULL,
        IndirizzoPalestraCorso varchar(50) NOT NULL,
        PRIMARY KEY (Cliente,NomeCorso,EdizioneCorso,CittaPalestraCorso,IndirizzoPalestraCorso),
        FOREIGN KEY (Cliente) REFERENCES Cliente (Cf) on update cascade on delete cascade,
        FOREIGN KEY (NomeCorso,EdizioneCorso,CittaPalestraCorso,IndirizzoPalestraCorso) REFERENCES Corso (Nome,Edizione,CittaPalestra,IndirizzoPalestra) on update cascade on delete cascade
    );


    -- Table Esercizio_Scheda --------------------------
    CREATE TABLE Esercizio_Scheda
    (
        Esercizio varchar(50) NOT NULL,
        Scheda int NOT NULL,
        SerieRipetizioni varchar(20) NOT NULL,
        TempoRecupero time NOT NULL,
        PRIMARY KEY (Scheda, Esercizio),
        FOREIGN KEY (Scheda) REFERENCES Scheda (Id) on update cascade on delete cascade,
        FOREIGN KEY (Esercizio) REFERENCES Esercizio (Nome) on update cascade on delete cascade
    );

    --Table Iscrizione--------------------------------
    CREATE TABLE Iscrizione
    (
        Id serial PRIMARY KEY,
        Scadenza date NOT NULL,
        Listino integer NOT NULL,
        Cliente varchar(16) NOT NULL,
        FOREIGN KEY (cliente) REFERENCES Cliente (Cf) on update cascade on delete cascade,
        FOREIGN KEY (Listino) REFERENCES ListinoPrezzi (Id) on update cascade on delete cascade
    );


    --Table Esercizio_gruppomuscolare-----------------
    CREATE TABLE Esercizio_gruppomuscolare
    (
        GruppoMuscolare varchar(20),
        Esercizio varchar(50), 
        PRIMARY KEY (Esercizio,GruppoMuscolare),
        FOREIGN KEY (Esercizio) REFERENCES Esercizio (Nome) on update cascade on delete cascade,
        FOREIGN KEY (GruppoMuscolare) REFERENCES GruppoMuscolare (Nome) on update cascade on delete cascade
    );

    --INIZIO INSERT---------------------------------------------------------------------------

    --insert for Cliente---------
    insert into Cliente (Cf,Nome,Cognome,Mail,DataNascita,Sesso) values 
    ('RSSMRA99A01F205U','Mario','Rossi','mario.rossi@gmail.com','1988-05-15','M'),
    ('VLCPTR85R45L789J','Valentina','Caputo','valentina.caputo@yahoo.com','1995-09-22','F'),
    ('GLNMRK73D19H123P','Giulio','Namari','giulio.namari@hotmail.com','1977-11-30','M'),
    ('FLRSPA88E03B456Q','Francesca','La Rosa','francesca.larosa@outlook.com','2001-03-05','F'),
    ('ALEBRT92M22G789R','Alessia','Berti','alessia.berti@icloud.com','1998-07-22','F'),
    ('MRNPLO81B11L567T','Marco','Napolitano','marco.napolitano@gmail.com','1981-09-11','M'),
    ('ELZCRL96T25A890P','Elisa','Carullo','elisa.carullo@yahoo.com','1996-10-25','F'),
    ('JNCPDR94M03E345D','Giovanni','Capodanno','giovanni.capodanno@live.com','1994-03-15','M'),
    ('CPRTSN89L20G567F','Caterina','Santoro','caterina.santoro@outlook.com','1989-12-20','F'),
    ('FRNCSC76D14H890M','Francesco','Crescenzo','francesco.crescenzo@gmail.com','1976-01-14','M'),
    ('MRLRBN88A02L123P','Miriam','Liberti','miriam.liberti@yahoo.com','1988-02-02','F'),
    ('ALBNCA83R25C456F','Alberto','Bianchi','alberto.bianchi@hotmail.com','1983-05-25','M'),
    ('GRTNLC91T10D789H','Giorgia','Tonalini','giorgia.tonalini@gmail.com','1991-10-10','F'),
    ('SLAPTR81M25L781D','Pedro','Scala','pedro.scala@gmail.com','25/08/1981','M'),
    ('MRSRGM80E15M234N','Marta','Rosso','marta.rosso@icloud.com','1980-12-15','F'),
    ('FLBRCO86F11P567R','Fabrizio','Colombo','fabrizio.colombo@yahoo.com','1986-06-11','M'),
    ('LLBRBR87L20E345S','Luca','Barbara','luca.barbara@live.com','1987-08-20','M'),
    ('MRLMNN93T14C890P','Mariella','Mannino','mariella.mannino@gmail.com','1993-04-14','F'),
    ('FBNCCC79D11Z345M','Fabio','Cocci','fabio.cocci@outlook.com','1979-11-11','M'),
    ('NDCMRC94M25Y567D','Nicole','Marchesi','nicole.marchesi@yahoo.com','1994-05-25','F'),
    ('PTRSSN88L03X890V','Patrizia','Rosselli','patrizia.rosselli@gmail.com','1988-03-03','F'),
    ('SMNRCH82A12K123B','Simone','Marchetti','simone.marchetti@hotmail.com','1982-12-12','M'),
    ('RMNTLC89R23G789T','Romina','Talenti','romina.talenti@yahoo.com','1989-02-23','F'),
    ('JNLMRC97M15L567X','Gianluca','Marconi','gianluca.marconi@icloud.com','1997-11-15','M'),
    ('ELNCRT85F14Z890N','Elena','Carotti','elena.carotti@gmail.com','1985-04-14','F'),
    ('FCMMLR80D22H567L','Francesco','Camilli','francesco.camilli@yahoo.com','1980-02-22','M'),
    ('CMNMDA91R12F890S','Carmen','Monaldi','carmen.monaldi@hotmail.com','1991-01-12','F'),
    ('GLNNCL84E05H567R','Giuliana','Nicoletti','giuliana.nicoletti@outlook.com','1984-05-05','F'),
    ('ALBRGL78M10J890M','Alberto','Borgese','alberto.borgese@yahoo.com','1978-09-10','M'),
    ('RVLLDE75A41E103P','Elodia','Raviolo','elodia@outlook.it','01/01/1975','F'),
    ('VLVGNO61S01L016X','Ogan','Valverde','ogan@hotmail.it','01/11/1961','M'),
    ('VRNCRL95A30N890H','Veronica','Carli','veronica.carli@hotmail.com','1995-07-30','F');

    --insert for Palestra---------
    insert into Palestra (Citta,Indirizzo,AperturaFeriali,ChiusuraFeriali,AperturaFestivi,ChiusuraFestivi) values
    ('Varese','Piazza Garibaldi, 22','6:00','22:00','8:00','14:00'),
    ('Pescara','Via Palmiro Togliatti','6:00','22:00','8:00','14:00'),
    ('Verona','Via dell''Artigliere, 8','6:00','22:00','8:00','14:00'),
    ('Padova','Via Luzzatti 250','6:00','22:00','8:00','14:00'),
    ('Venezia','Località Martellago 130','6:00','22:00','8:00','14:00');

    --insert for Istruttore--------------------------
    insert into Istruttore (Cf,Nome,Cognome,DataNascita,Sesso,CittaPalestra,IndirizzoPalestra) values
    ('RSSMRA99A01F205R','Roberto','Rossi','1995-04-15','M','Varese','Piazza Garibaldi, 22'),
    ('VLCPTR85R45L789K','Valeria','Caputo','1990-09-22','F','Varese','Piazza Garibaldi, 22'),
    ('GLNMRK98D19H123P','Gabriele','Namari','1992-11-30','M','Varese','Piazza Garibaldi, 22'),
    ('FLRSPA93E03B456Q','Francesca','La Rosa','1999-03-05','F','Varese','Piazza Garibaldi, 22'),
    ('ALEBRT91M22G789R','Alessandro','Berti','1991-07-22','M','Varese','Piazza Garibaldi, 22'),

    ('MRNPLO89B11L567T','Marco','Napolitano','1997-09-11','M','Pescara','Via Palmiro Togliatti'),
    ('ELZCRL95T25A890P','Elisa','Carullo','1995-10-25','F','Pescara','Via Palmiro Togliatti'),
    ('JNCPDR96M03E345D','Giovanna','Capodanno','1996-03-15','F','Pescara','Via Palmiro Togliatti'),
    ('CPRTSN88L20G567F','Cristiano','Santoro','1988-12-20','M','Pescara','Via Palmiro Togliatti'),
    ('FRNCSC94D14H890M','Francesco','Crescenzo','1994-01-14','M','Pescara','Via Palmiro Togliatti'),

    ('MRLRBN93A02L123P','Marianna','Liberti','1993-02-02','F','Verona','Via dell''Artigliere, 8'),
    ('ALBNCA96R25C456F','Alberto','Bianchi','1996-05-25','M','Verona','Via dell''Artigliere, 8'),
    ('GRTNLC95T10D789H','Giorgia','Tonalini','1995-10-10','F','Verona','Via dell''Artigliere, 8'),
    ('MRSRGM92E15M234N','Mario','Rosso','1992-12-15','M','Verona','Via dell''Artigliere, 8'),
    ('FLBRCO99F11P567R','Fabrizia','Colombo','1999-06-11','F','Verona','Via dell''Artigliere, 8'),

    ('VRNCRL98A30N890H','Vincenzo','Carli','1998-07-30','M','Padova','Via Luzzatti 250'),
    ('LLBRBR95L20E345S','Lorenzo','Barbara','1995-08-20','M','Padova','Via Luzzatti 250'),
    ('MRLMNN89T14C890P','Mariella','Mannino','1989-04-14','F','Padova','Via Luzzatti 250'),
    ('FBNCCC91D11Z345M','Fabio','Cocci','1991-11-11','M','Padova','Via Luzzatti 250'),

    ('SMNRCH94A12K123B','Simone','Marchiori','1994-12-12','M','Venezia','Località Martellago 130'),
    ('PTRSSN92L03X890V','Petra','Rossini','1992-03-03','F','Venezia','Località Martellago 130'),
    ('RMNTLC98R23G789T','Romina','Tallucci','1998-02-23','F','Venezia','Località Martellago 130'),
    ('ELNCRT98F14Z890N','Elina','Corruti','1998-04-14','F','Venezia','Località Martellago 130'),
    ('JNLMRC00M15L567X','Gianluca','Marchi','2000-11-15','M','Venezia','Località Martellago 130');

    --insert for ListinoPrezzi
    insert into ListinoPrezzi (PrezzoAreaFitnessMensile,PrezzoIscrizione) values
    (25,40),
    (30,40),
    (35,50);

    --insert for Areafitness
    insert into Areafitness (DataInizio,DataFine,Cliente,Listino) values
    ('2023-07-11','2023-10-11','RSSMRA99A01F205U',3),
    ('2023-06-15','2023-12-15','VLCPTR85R45L789J',3),
    ('2023-02-02','2023-05-02','VLCPTR85R45L789J',3),
    ('2023-06-30','2024-06-30','GLNMRK73D19H123P',3),
    ('2023-08-20','2023-11-20','FLRSPA88E03B456Q',3),
    ('2023-02-10','2023-08-10','FLRSPA88E03B456Q',2),
    ('2022-09-30','2023-09-30','ALEBRT92M22G789R',2),
    ('2021-06-30','2022-06-30','ALEBRT92M22G789R',1),
    ('2023-04-01','2023-07-01','MRNPLO81B11L567T',3),
    ('2022-08-10','2023-08-10','ELZCRL96T25A890P',2),
    ('2022-12-25','2023-06-25','JNCPDR94M03E345D',2),
    ('2022-03-15','2023-03-15','CPRTSN89L20G567F',2),
    ('2021-09-05','2022-03-05','CPRTSN89L20G567F',1),
    ('2022-04-05','2023-04-05','FRNCSC76D14H890M',2),
    ('2023-08-15','2023-11-15','MRLRBN88A02L123P',3),
    ('2023-08-28','2024-02-28','ALBNCA83R25C456F',3),
    ('2021-09-20','2022-09-20','GRTNLC91T10D789H',1), 
    ('2021-06-10','2022-06-10','ALBNCA83R25C456F',1),
    ('2023-09-10','2023-12-10','MRSRGM80E15M234N',3),
    ('2022-10-05','2023-10-05','FLBRCO86F11P567R',2),
    ('2021-01-01','2022-01-01','SLAPTR81M25L781D',1),
    ('2022-01-01','2023-01-01','SLAPTR81M25L781D',2),
    ('2023-01-01','2024-01-01','SLAPTR81M25L781D',3);

    UPDATE Areafitness a
    SET Prezzo = 
    ((EXTRACT(YEAR FROM a.dataFine) - EXTRACT(YEAR FROM a.dataInizio)) * 12 +
    EXTRACT(MONTH FROM a.dataFine) - EXTRACT(MONTH FROM a.dataInizio))
    * l.PrezzoAreaFitnessMensile
    FROM ListinoPrezzi l
    WHERE a.listino = l.id;

    --insert for Corso
    insert into Corso (Nome,Edizione,Orario,DataInizio,DataFine,CittaPalestra,IndirizzoPalestra,Istruttore,NumeroMaxPartecipanti,Prezzo, Descrizione) values
    --Varese
    ('Zumba',1,                 'Lunedì e Mercoledì 8-10','2021-01-01', '2021-06-01','Varese','Piazza Garibaldi, 22','RSSMRA99A01F205R',30,24.99,'Un allenamento energico che combina danza e fitness'),
    ('Zumba',2,                 'Lunedì e Mercoledì 8-10','2022-06-10', '2022-12-10','Varese','Piazza Garibaldi, 22','RSSMRA99A01F205R',30,24.99,'Un allenamento energico che combina danza e fitness per migliorare il ritmo cardiaco.'),
    ('Zumba',3,                 'Lunedì e Mercoledì 8-10','2023-01-01', '2023-06-01','Varese','Piazza Garibaldi, 22','RSSMRA99A01F205R',30,29.99,'Un allenamento energico che combina danza e fitness per migliorare il ritmo cardiaco e il divertimento'),

    ('Yoga',1,                  'Martedì e Giovedì 8-10', '2022-01-01', '2022-06-01','Varese','Piazza Garibaldi, 22','RSSMRA99A01F205R',30,22,'Una pratica di rilassamento e flessibilità che unisce mente e corpo attraverso movimenti fluidi e respiri consapevoli.'),
    ('Yoga',2,                  'Martedì e Giovedì 8-10', '2022-06-10', '2022-12-10','Varese','Piazza Garibaldi, 22','RSSMRA99A01F205R',30,22,'Una pratica di rilassamento e flessibilità che unisce mente e corpo attraverso movimenti fluidi e respiri consapevoli.'),

    ('Spinning',1,              'Mercoledì e Venerdì 18-20', '2022-01-01', '2022-06-01','Varese','Piazza Garibaldi, 22','VLCPTR85R45L789K',22,17.99,'Un allenamento cardio ad alta intensità su biciclette stazionarie, perfetto per migliorare la resistenza e la forza delle gambe.'),
    ('Spinning',2,              'Mercoledì e Venerdì 18-20', '2022-06-10', '2022-12-10','Varese','Piazza Garibaldi, 22','VLCPTR85R45L789K',22,19.99,'Un allenamento cardio ad alta intensità su biciclette stazionarie, perfetto per migliorare la resistenza e la forza delle gambe.'),

    ('Pilates',1,               'Lunedì e Mercoledì 14-16', '2023-01-01', '2023-06-01','Varese','Piazza Garibaldi, 22','GLNMRK98D19H123P',30,19.99,'Un metodo di esercizio che si concentra sulla forza del core, la postura e la flessibilità per migliorare l''allineamento corporeo.'),

    ('Functional Training',1,   'Mercoledì e Giovedì 18-20', '2022-01-01', '2022-06-01','Varese','Piazza Garibaldi, 22','FLRSPA93E03B456Q',22,24.99,'Un approccio all''allenamento che mira a migliorare le abilità funzionali.'),
    ('Functional Training',2,   'Mercoledì e Giovedì 18-20', '2022-06-01', '2022-12-01','Varese','Piazza Garibaldi, 22','FLRSPA93E03B456Q',22,29.99,'Un approccio all''allenamento che mira a migliorare le abilità funzionali attraverso movimenti complessi e naturali.'),
    ('Functional Training',3,   'Mercoledì e Giovedì 18-20', '2023-01-01', '2023-06-01','Varese','Piazza Garibaldi, 22','FLRSPA93E03B456Q',30,34.99,'Un approccio all''allenamento che mira a migliorare le abilità funzionali attraverso movimenti complessi e naturali.'),
    ('Functional Training',4,   'Mercoledì e Giovedì 18-20', '2023-06-01', '2023-12-01','Varese','Piazza Garibaldi, 22','ALEBRT91M22G789R',30,34.99,'Un approccio all''allenamento che mira a migliorare le abilità funzionali attraverso movimenti complessi e naturali.'),

    ('Calisthenics',1,          'Mercoledì e Venerdì 16-17', '2023-03-01', '2023-05-01','Varese','Piazza Garibaldi, 22','VLCPTR85R45L789K',10,45,'Un allenamento basato su esercizi di peso corporeo che sviluppa forza, flessibilità e coordinazione.'),


    --Pescara
    ('Zumba',1,                 'Lunedì e Mercoledì 09-11', '2022-01-01', '2022-06-01','Pescara','Via Palmiro Togliatti','MRNPLO89B11L567T',15,25,'Un allenamento energico che combina danza e fitness'),
    ('Zumba',2,                 'Lunedì e Mercoledì 09-11', '2022-06-02', '2022-12-01','Pescara','Via Palmiro Togliatti','MRNPLO89B11L567T',15,25,'Un allenamento energico che combina danza e fitness'),

    ('Stretching e Mobilità',1, 'Martedì e Mercoledì 08-10', '2022-01-01', '2022-06-01','Pescara','Via Palmiro Togliatti','JNCPDR96M03E345D',15,16,'Un allenamento focalizzato sull''allungamento muscolare e la mobilità articolare per mantenere il corpo flessibile.'),

    ('Total Body',1,            'Domenica 09-11', '2022-06-01', '2022-08-01','Pescara','Via Palmiro Togliatti','CPRTSN88L20G567F',15,25,'Un programma che coinvolge tutti i gruppi muscolari per un allenamento completo e bilanciato.'),
    ('Total Body',2,            'Domenica 09-11', '2023-06-01', '2023-08-01','Pescara','Via Palmiro Togliatti','CPRTSN88L20G567F',15,25,'Un programma che coinvolge tutti i gruppi muscolari per un allenamento completo e bilanciato.'),

    ('Ginnastica Posturale',1,  'Lunedì, Mercoledì e Venerdì 20-22', '2022-03-01', '2022-06-01','Pescara','Via Palmiro Togliatti','FRNCSC94D14H890M',15,30,'Un allenamento focalizzato sul miglioramento della postura.'),
    ('Ginnastica Posturale',2,  'Lunedì, Mercoledì e Venerdì 18-20', '2022-06-01', '2022-09-01','Pescara','Via Palmiro Togliatti','FRNCSC94D14H890M',15,30,'Un allenamento focalizzato sul miglioramento della postura, della flessibilità e dell''equilibrio.'),

    ('Power Yoga',1,            'Martedì e Mercoledì 15-16', '2022-06-01', '2022-12-01','Pescara','Via Palmiro Togliatti','MRNPLO89B11L567T',15,25,'Una variante dinamica dello yoga che combina movimenti fluidi con elementi di forza e resistenza.'),


    --Verona

    ('Zumba',1,                 'Lunedì e Mercoledì 10-12', '2021-01-01', '2021-12-01','Verona','Via dell''Artigliere, 8','MRLRBN93A02L123P',22,25,'Un allenamento energico che combina danza e fitness'),

    ('Pilates',1,               'Lunedì e Giovedì 15-17', '2021-01-01', '2021-12-22','Verona','Via dell''Artigliere, 8','MRSRGM92E15M234N',28,20,'Un metodo di esercizio che si concentra sulla forza del core, la postura e la flessibilità per migliorare l''allineamento corporeo.'),
    ('Pilates',2,               'Lunedì e Giovedì 16-18', '2022-01-01', '2022-12-22','Verona','Via dell''Artigliere, 8','MRSRGM92E15M234N',28,20,'Un metodo di esercizio che si concentra sulla forza del core, la postura e la flessibilità per migliorare l''allineamento corporeo.'),

    ('Calisthenics',1,          'Martedì e Giovedì 13-14', '2023-05-01', '2023-07-16','Verona','Via dell''Artigliere, 8','FLBRCO99F11P567R',22,30,'Un allenamento basato su esercizi di peso corporeo che sviluppa forza, flessibilità e coordinazione.'),
    ('Calisthenics',2,          'Martedì e Venerdì 13-14', '2023-07-20', '2023-09-25','Verona','Via dell''Artigliere, 8','FLBRCO99F11P567R',22,30,'Un allenamento basato su esercizi di peso corporeo che sviluppa forza, flessibilità e coordinazione.'),

    ('CrossFit',1,              'Martedì e Sabato 17-19', '2021-01-01', '2021-06-02','Verona','Via dell''Artigliere, 8','MRLRBN93A02L123P',22,35.50,'Cardio e ginnastica per una forma fisica completa.'),
    ('CrossFit',2,              'Martedì e Sabato 17-19', '2021-06-12', '2021-12-22','Verona','Via dell''Artigliere, 8','MRLRBN93A02L123P',22,35.50,'Un metodo di allenamento ad alta intensità che combina sollevamento pesi, cardio e ginnastica per una forma fisica completa.'),
    ('CrossFit',3,              'Martedì e Mercoledì 17-19', '2022-01-01', '2022-06-10','Verona','Via dell''Artigliere, 8','MRLRBN93A02L123P',22,36,'Un metodo di allenamento ad alta intensità che combina sollevamento pesi, cardio e ginnastica per una forma fisica completa.'),
    ('CrossFit',4,              'Martedì e Sabato 17-19', '2022-06-20', '2022-12-20','Verona','Via dell''Artigliere, 8','MRLRBN93A02L123P',28,36,'Un metodo di allenamento ad alta intensità che combina sollevamento pesi, cardio e ginnastica per una forma fisica completa.'),


    --Padova
    ('Zumba',1,                 'Lunedì e Mercoledì 10-12', '2022-01-01', '2022-12-01','Padova','Via Luzzatti 250','VRNCRL98A30N890H',10,25,'Un allenamento energico che combina danza e fitness'),

    ('Spinning',1,              'Martedì e Giovedì 18-20', '2021-01-01', '2021-12-01','Padova','Via Luzzatti 250','LLBRBR95L20E345S',25,22,'Un allenamento cardio ad alta intensità su biciclette stazionarie.'),
    ('Spinning',2,              'Martedì e Giovedì 18-20', '2022-01-01', '2022-12-01','Padova','Via Luzzatti 250','LLBRBR95L20E345S',25,22,'Un allenamento cardio ad alta intensità su biciclette stazionarie.'),
    ('Spinning',3,              'Martedì e Giovedì 18-20', '2023-01-01', '2023-06-28','Padova','Via Luzzatti 250','LLBRBR95L20E345S',25,22,'Un allenamento cardio ad alta intensità su biciclette stazionarie, perfetto per migliorare la resistenza e la forza delle gambe.'),
    ('Spinning',4,              'Martedì e Giovedì 18-20', '2023-07-01', '2023-12-22','Padova','Via Luzzatti 250','LLBRBR95L20E345S',25,22,'Un allenamento cardio ad alta intensità su biciclette stazionarie, perfetto per migliorare la resistenza e la forza delle gambe.'),

    ('Functional Training',1,   'Martedì e Giovedì 06-08', '2022-01-01', '2022-06-29','Padova','Via Luzzatti 250','MRLMNN89T14C890P',10,30,'Un approccio all''allenamento che mira a migliorare le abilità funzionali attraverso movimenti complessi e naturali.'),
    ('Functional Training',2,   'Martedì e Giovedì 08-10', '2023-01-18', '2023-07-01','Padova','Via Luzzatti 250','MRLMNN89T14C890P',10,30,'Un approccio all''allenamento che mira a migliorare le abilità funzionali attraverso movimenti complessi e naturali.'),

    ('Boxe Fit',1,              'Giovedì e Sabato 16-18', '2022-01-01', '2022-05-01','Padova','Via Luzzatti 250','FBNCCC91D11Z345M',10,39.99,'Un allenamento ispirato alla boxe che include movimenti e combinazioni per la resistenza cardio e il tono muscolare.'),
    ('Boxe Fit',2,              'Giovedì e Sabato 16-18', '2022-05-10', '2022-12-01','Padova','Via Luzzatti 250','FBNCCC91D11Z345M',10,39.99,'Un allenamento ispirato alla boxe che include movimenti e combinazioni per la resistenza cardio e il tono muscolare.'),


    --Venezia
    ('Zumba',1,                 'Lunedì e Giovedì 10-11:30', '2021-01-01', '2021-06-22','Venezia','Località Martellago 130','PTRSSN92L03X890V',15,27.99,'Un allenamento energico che combina danza e fitness'),
    ('Zumba',2,                 'Lunedì e Giovedì 10-11:30', '2021-07-01', '2021-12-20','Venezia','Località Martellago 130','PTRSSN92L03X890V',15,27.99,'Un allenamento energico che combina danza e fitness'),
    ('Zumba',3,                 'Lunedì e Giovedì 10-11:30', '2022-01-01', '2022-12-22','Venezia','Località Martellago 130','SMNRCH94A12K123B',15,27.99,'Un allenamento energico che combina danza e fitness'),
    ('Zumba',4,                 'Lunedì e Giovedì 10-11:30', '2023-01-01', '2023-12-22','Venezia','Località Martellago 130','SMNRCH94A12K123B',15,27.99,'Un allenamento energico che combina danza e fitness'),

    ('Yoga',1,                  'Martedì e Giovedì 12-13:15', '2022-01-14', '2022-05-22','Venezia','Località Martellago 130','SMNRCH94A12K123B',15,25,'Una pratica di rilassamento e flessibilità che unisce mente e corpo.'),

    ('Circuit Training',1,      'Sabato e Domenicaì 10-12', '2023-03-01', '2023-05-22','Venezia','Località Martellago 130','RMNTLC98R23G789T',15,40,'Un allenamento completo del corpo che prevede una serie di esercizi rapidi e intensi.'),

    ('Aqua Fitness',1,          'Mercoledì e Venerdì 16-18', '2022-01-11', '2022-06-20','Venezia','Località Martellago 130','JNLMRC00M15L567X',15,20,'Un allenamento in acqua che riduce l''effetto sulle articolazioni.'),
    ('Aqua Fitness',2,          'Mercoledì e Venerdì 16-18', '2022-06-27', '2022-12-22','Venezia','Località Martellago 130','JNLMRC00M15L567X',15,20,'Un allenamento in acqua che riduce l''effetto sulle articolazioni e migliora la resistenza muscolare.'),
    ('Aqua Fitness',3,          'Mercoledì e Venerdì 17-19', '2023-01-09', '2023-07-22','Venezia','Località Martellago 130','JNLMRC00M15L567X',15,25,'Un allenamento in acqua che riduce l''effetto sulle articolazioni e migliora la resistenza muscolare.');

    --insert for Scheda--------------------------------------------------
    insert into Scheda (Areafitness,DataInizio,DataFine,Istruttore) values
    (1,'2023-07-11','2023-08-26','RSSMRA99A01F205R'),
    (1,'2023-08-30','2023-10-05','RSSMRA99A01F205R'),
    (2,'2023-06-15','2023-07-30','VLCPTR85R45L789K'),
    (2,'2023-08-01','2023-10-26','VLCPTR85R45L789K'),
    (3,'2023-02-02','2023-04-03','GLNMRK98D19H123P'),
    (3,'2023-04-10','2023-05-20','GLNMRK98D19H123P'),
    (4,'2023-06-30','2023-09-12','FLRSPA93E03B456Q'),
    (5,'2023-08-20','2023-10-03','ALEBRT91M22G789R'),
    (6,'2023-02-10','2023-04-16','MRNPLO89B11L567T'),
    (6,'2023-04-20','2023-06-26','MRNPLO89B11L567T'),
    (6,'2023-06-30','2023-08-20','MRNPLO89B11L567T'),
    (8,'2021-06-30','2021-09-03','JNCPDR96M03E345D'),
    (8,'2021-09-30','2021-12-04','JNCPDR96M03E345D'),
    (8,'2022-02-03','2022-05-03','JNCPDR96M03E345D'),
    (8,'2022-05-20','2022-07-10','JNCPDR96M03E345D'),
    (8,'2022-05-20','2022-07-10','MRNPLO89B11L567T'),
    (7,'2022-09-30','2022-12-03','CPRTSN88L20G567F'),
    (7,'2023-02-03','2023-04-28','CPRTSN88L20G567F'),
    (7,'2022-04-30','2022-06-20','CPRTSN88L20G567F'),
    (7,'2022-07-30','2022-09-20','CPRTSN88L20G567F'),
    (9,'2023-04-10','2023-06-21','GLNMRK98D19H123P'),
    (10,'2022-08-10','2022-11-06','FLRSPA93E03B456Q'),
    (10,'2023-01-12','2023-03-01','FLRSPA93E03B456Q'),
    (10,'2023-04-10','2023-06-06','FLRSPA93E03B456Q'),
    (10,'2023-07-11','2023-09-05','FLRSPA93E03B456Q'),
    (11,'2022-12-25','2023-02-02','ALEBRT91M22G789R'),
    (11,'2023-03-01','2023-05-04','ALEBRT91M22G789R'),
    (13,'2021-09-05','2021-12-16','RSSMRA99A01F205R'),
    (13,'2022-01-15','2022-03-12','RSSMRA99A01F205R'),
    (12,'2022-04-17','2022-06-27','GLNMRK98D19H123P'),
    (12,'2022-08-20','2022-11-20','GLNMRK98D19H123P'),
    (12,'2022-12-13','2023-04-11','GLNMRK98D19H123P'),
    (14,'2022-04-05','2022-08-10','FBNCCC91D11Z345M'),
    (15,'2023-08-15','2023-11-14','MRNPLO89B11L567T'),
    (16,'2023-08-28','2023-11-15','ALBNCA96R25C456F'),
    (17,'2021-09-20','2021-12-11','JNLMRC00M15L567X'),
    (17,'2022-03-20','2022-05-21','JNLMRC00M15L567X'),
    (17,'2022-06-20','2022-09-01','JNLMRC00M15L567X'),
    (18,'2021-06-10','2021-08-03','FBNCCC91D11Z345M'),
    (18,'2021-09-20','2021-12-03','FBNCCC91D11Z345M'),
    (18,'2022-02-10','2022-05-03','FBNCCC91D11Z345M'),
    (20,'2022-10-05','2022-12-14','GRTNLC95T10D789H'),
    (21,'2021-01-01','2021-04-01','SMNRCH94A12K123B'),
    (21,'2021-04-01','2021-07-01','SMNRCH94A12K123B'),
    (21,'2021-10-01','2022-01-01','SMNRCH94A12K123B'),
    (22,'2022-01-01','2022-04-01','LLBRBR95L20E345S'),
    (22,'2022-04-01','2022-07-01','LLBRBR95L20E345S'),
    (22,'2022-10-01','2023-01-01','ELNCRT98F14Z890N'),
    (23,'2023-01-01','2023-04-01','ELNCRT98F14Z890N'),
    (23,'2023-04-01','2023-07-01','ELNCRT98F14Z890N');

    --insert for Esercizio------------------
    insert into Esercizio (Nome,Descrizione) values
    ('Chest press','Spingere il bilancere verso l''alto sopra il proprio petto, è essenziale mantenere la schiena inarcata durante l''esecuzuione per togliere lo sforzo sulle spalle econcentrare il peso dul petto'),
    ('Lat machine avanti','Tirare il manubrio verso il petto mentre sei seduto.'),
    ('Curl in piedi bilanciere','Piegare il gomito per sollevare un bilanciere verso le spalle.'),
    ('Alzate laterali in piedi manubri','Sollevare i manubri lateralmente fino alla linea delle spalle.'),
    ('Extrarotazioni stile l in piedi elastico','Tirare un elastico lateralmente mentre tieni le braccia in posizione a forma di "L".'),
    ('Panca piana bilanciere','Spingere un bilanciere verso l''alto mentre sei sdraiato sulla panca.'),
    ('Panca inclinata manubri','Spingere manubri verso l''alto mentre sei sdraiato su una panca inclinata.'),
    ('Dip alle parallele','Abbassare e sollevare il corpo utilizzando le parallele.'),
    ('Trazioni presa prona','Tirare il corpo verso l''alto afferrando una barra con le mani in posizione inversa.'),
    ('Pulley basso triangolo','Tirare un cavo verso il basso mentre sei in piedi, utilizzando un attacco a forma di triangolo.'),
    ('Squat bilanciere','Piegare le ginocchia e abbassare il corpo tenendo un bilanciere sulla schiena, quindi ritornare in posizione eretta spingendo attraverso i talloni.'),
    ('Leg extension','Sedersi su una macchina apposita, estendere le gambe sollevando il peso, quindi abbassarlo controllatamente'),
    ('Shoulder press','In piedi o seduto, spingere i pesi verso l alto sopra la testa'),
    ('Gatto','Esercizio che coinvolge il piegamento e l"allungamento della colonna vertebrale, spesso usato per il riscaldamento o il rilassamento.'),
    ('Plank','Mantenere il corpo in posizione orizzontale sospeso sulle braccia o sui gomiti e le punte dei piedi, per rafforzare la core.'),
    ('Calf in piedi su rialzo bilanciere','Sollevare i talloni stando su un rialzo e tenendo un bilanciere sulle spalle, per allenare i muscoli polpacci'),
    ('Rematore in piedi bilanciere','Tirare un bilanciere verso il corpo mantenendo la schiena dritta, per lavorare sulla schiena e i muscoli dorsali.'),
    ('Push up','Flessioni dal pavimento, coinvolgendo pettorali, tricipiti e core'),
    ('Leg curl',' Sedersi su una macchina specifica, piegare le gambe per portare i talloni verso i glutei sollevando il peso, quindi abbassarlo controllatamente, per lavorare sui muscoli posteriori della coscia'),
    ('Curl in piedi cavo basso con sbarra','Tirare una sbarra verso l"alto con le mani mentre sei in piedi, focalizzandoti sui muscoli bicipiti'),
    ('Tapis roulant','Camminare o correre su una piattaforma mobile, utilizzato per l"allenamento cardiovascolare'),
    ('French press bilanciere panca piana','Sollevare un bilanciere sopra il petto e poi estendere le braccia verso l"alto per allenare i tricipiti'),
    ('Curl 2 manubri in piedi','Sollevare due manubri verso le spalle mantenendo le braccia fisse, per lavorare sui muscoli bicipiti'),
    ('Alzate gamba su fianco a terra','Sollevare una gamba lateralmente tenendo l"altra ferma, per lavorare sugli adduttori e gli abduttori delle gambe'),
    ('Alzate laterali singolo cavo in piedi','Sollevare un cavo lateralmente tenendo un solo braccio in movimento, per lavorare sui deltoidi laterali'),
    ('Chiusure seduto adductor machine','Sedersi su una macchina dedicata e spingere le gambe l"una contro l"altra per lavorare sugli adduttori delle cosce'),
    ('Aperture peck back','Sedersi su una macchina specifica e spingere le braccia verso l"esterno per lavorare sui muscoli pettorali'),
    ('Lat pulldown', 'Tirare una barra verso il petto da una posizione in piedi o seduta, per lavorare sulla schiena e i muscoli dorsali.'),
    ('Crunch', 'Sollevare la parte superiore del corpo dal pavimento, coinvolgendo i muscoli addominali.'),
    ('Deadlift', 'Sollevamento da terra di un bilanciere, coinvolgendo vari gruppi muscolari'),
    ('Bench press', 'Sollevamento di un bilanciere disteso su una panca, per lavorare principalmente sui muscoli pettorali.'),
    ('Hammer curl', 'Flessioni del gomito con manubri tenuti in posizione neutra, per lavorare sui muscoli delle braccia.'),
    ('Leg press', 'Spinta delle gambe contro una piattaforma pesante, per lavorare sui muscoli delle gambe.'),
    ('Calf raise', 'Sollevamento del tallone in piedi per lavorare sui muscoli dei polpacci.'),
    ('Military press', 'Sollevamento di un bilanciere sopra la testa in posizione eretta, per lavorare sulle spalle'),
    ('Dumbbell flyes', 'Sollevamento di manubri tenuti in posizione neutra davanti al petto, per lavorare sui muscoli pettorali.'),
    ('Lunges', 'Passi in avanti alternati per lavorare sulle gambe.'),
    ('Bent-over rows', 'Tirare un bilanciere verso il corpo da una posizione piegata in avanti, per lavorare sulla schiena'),
    ('Flessioni tricipiti', 'Flessioni del gomito all''indietro, per lavorare sui tricipiti.'),
    ('Stacco rumeno', 'Piegarsi in avanti dalla vita con un bilanciere in mano, per lavorare sulla parte posteriore delle gambe e sulla schiena'),
    ('Squat sumo', 'Squat eseguito con le gambe ben divaricate, per lavorare sui muscoli delle gambe'),
    ('Pressa Arnold', 'Sollevamento di manubri sopra la testa con un movimento rotatorio, per lavorare sulle spalle'),
    ('Rematore al cavo', 'Tirare un cavo verso il corpo, per lavorare sulla schiena.'),
    ('Plank laterale', 'Posizione di planca laterale per rinforzare la core e i muscoli laterali.'),
    ('Russian twists', 'Movimento di rotazione del busto per lavorare sugli obliqui.'),
    ('Curl femorali seduto', 'Flessioni delle gambe su un''apparecchiatura specifica, per lavorare sui muscoli posteriori delle cosce.'),
    ('Dumbbell pullover', 'Sollevamento di un manubrio sopra la testa mentre sei disteso, per lavorare su petto e schiena.'),
    ('Alzate laterali', 'Sollevamento di manubri lateralmente per lavorare sulle spalle.'),
    ('Trazione inversa', 'Trazione del corpo verso l''alto con il palmo delle mani rivolto verso il corpo, per lavorare sulla schiena e i bicipiti'),
    ('Alzate posteriori', 'Sollevamento di manubri all''indietro per lavorare sulle spalle posteriori.'),
    ('Estensioni per tricipiti', 'Estensione delle braccia sopra la testa per lavorare sui tricipiti.'),
    ('Rematore seduto al cavo basso', 'Tirare un cavo verso il corpo da una posizione seduta, per lavorare sulla schiena.'),
    ('Squat frontale', 'Squat con il bilanciere posizionato frontalmente, per lavorare sulle gambe.'),
    ('Ponte glutei', 'Sollevamento del bacino per lavorare sui glutei.'),
    ('Leg curl seduto', 'Flessioni delle gambe su un''apparecchiatura specifica mentre sei seduto, per lavorare sui muscoli posteriori delle cosce.'),
    ('Curl martello', 'Flessioni del gomito con manubri tenuti in posizione neutra, per lavorare sui muscoli delle braccia.'),
    ('Squat bulgaro', 'Squat con una gamba all''indietro appoggiata su una superficie, per lavorare sulle gambe.'),
    ('Pressa spalle', 'Sollevamento di un bilanciere sopra la testa in posizione eretta, per lavorare sulle spalle.'),
    ('Curl concentrato', 'Flessioni del gomito con il braccio appoggiato sulla coscia, per lavorare sui muscoli delle braccia.'),
    ('Tritonatori tricipiti', 'Esercizio specifico per i tricipiti.'),
    ('Good morning', 'Inclinazione in avanti del busto con il bilanciere sulla schiena, per lavorare sulla parte bassa della schiena e i muscoli posteriori delle cosce.'),
    ('Addominali crunch su fitball', 'Esecuzione di crunch addominali con l''ausilio di una palla fitness.'),
    ('Curl femorali in piedi', 'Flessioni delle gambe in piedi su un''apparecchiatura specifica, per lavorare sui muscoli posteriori delle cosce.'),
    ('Push up sulle ginocchia', 'Flessioni sulle ginocchia anziché sui piedi, per semplificare l''esercizio.'),
    ('Estensioni tricipiti al cavo', 'Estensione delle braccia con un cavo per lavorare sui tricipiti.'),
    ('Leg curl a 45 gradi', 'Flessioni delle gambe su un''apparecchiatura specifica a un angolo di 45 gradi, per lavorare sui muscoli posteriori delle cosce.'),
    ('Affondi', 'Passi in avanti o all''indietro alternati, per lavorare sulle gambe.'),
    ('Clean and press', 'Sollevamento di un bilanciere da terra fino sopra la testa in un movimento continuo, per lavorare su vari gruppi muscolari.'),
    ('Dorsali pull over', 'Sollevamento di un bilanciere da terra fino sopra la testa, per lavorare sulla schiena.'),
    ('Squat goblet', 'Squat con un manubrio tenuto vicino al petto, per lavorare sulle gambe.'),
    ('Estensioni per tricipiti al cavo alto', 'Estensione delle braccia sopra la testa con un cavo, per lavorare sui tricipiti.'),
    ('Stacchi rumeni su panca', 'Esecuzione di stacchi rumeni tenendo i piedi su una panca, per lavorare sulla parte posteriore delle gambe e la schiena.'),
    ('Crunch inverso', 'Sollevamento delle gambe e dei fianchi verso l''alto da una posizione supina, coinvolgendo i muscoli addominali inferiori.'),
    ('Bent-over lateral raise', 'Sollevamento laterale dei manubri da una posizione piegata in avanti, per lavorare sulle spalle.'),
    ('Squat hack', 'Squat eseguito con il corpo in posizione inclinata all''indietro, per lavorare sulle gambe.'),
    ('Shoulder press con manubri', 'Sollevamento dei manubri sopra la testa in posizione eretta, per lavorare sulle spalle.'),
    ('Reverse crunch', 'Sollevamento delle gambe e dei fianchi verso il petto da una posizione supina, coinvolgendo i muscoli addominali inferiori.'),
    ('Trazioni alla sbarra', 'Sollevamento del corpo afferrando una sbarra, per lavorare sulla schiena e i bicipiti.'),
    ('Leg curl a 90 gradi', 'Flessioni delle gambe su un''apparecchiatura specifica a un angolo di 90 gradi, per lavorare sui muscoli posteriori delle cosce.'),
    ('Curl con manubri in supinazione', 'Flessioni del gomito con manubri tenuti in posizione di supinazione, per lavorare sui muscoli delle braccia.'),
    ('Leg press orizzontale', ' Spinta delle gambe in orizzontale su un''apparecchiatura specifica, per lavorare sui muscoli delle gambe.'),
    ('Sollevamento laterale con manubri', 'Sollevamento laterale dei manubri per lavorare sulle spalle.'),
    ('Plank laterale con sollevamento gamba', 'Posizione di plank laterale con sollevamento alternato delle gambe, per lavorare sulla core e i muscoli laterali.'),
    ('Pulley alto', 'Utilizzo di un cavo in alto per eseguire diversi esercizi di trazione.'),
    ('Squat bulgaro con manubri', 'Squat con una gamba all''indietro appoggiata su una superficie e l''uso di manubri, per lavorare sulle gambe.'),
    ('French press con manubri', 'Estensione delle braccia sopra la testa con manubri, per lavorare sui muscoli dei tricipiti.'),
    ('Reverse hyperextension', 'Estensione delle gambe all''indietro da una panca, per lavorare sulla parte bassa della schiena e i glutei.');

    --insert for GruppoMuscolare-------------
    insert into GruppoMuscolare (Nome,Categoria) values
    ('Abduttori','Gambe'),
    ('Addominali','Busto'),
    ('Addutori','Gambe'),
    ('Avambracci','Braccia'),
    ('Bicipiti','Braccia'),
    ('Cardio','Resistenza'),
    ('Dorsali','Schiena'),
    ('Femorali','Gambe'),
    ('Full Body',NULL),
    ('Glutei','Gambe'),
    ('Pettorali','Busto'),
    ('Polpacci','Gambe'),
    ('Quadricipiti','Gambe'),
    ('Riabilitazione',NULL),
    ('Rotatori spalla','Spalle'),
    ('Spalle','Spalle'),
    ('Stretching',NULL),
    ('Trapezi','Schiena'),
    ('Tricipiti','Braccia');

    --insert for Iscrizione
    insert into Iscrizione (Scadenza,Cliente,Listino) values
    --area fitness
    ('2024-07-11','RSSMRA99A01F205U',3),                 
    ('2024-06-15','VLCPTR85R45L789J',3),                
    ('2024-02-02','VLCPTR85R45L789J',3),                
    ('2024-06-30','GLNMRK73D19H123P',3),              
    ('2024-02-10','FLRSPA88E03B456Q',3),            
    ('2022-06-30','ALEBRT92M22G789R',1),--pescara
    ('2023-09-30','ALEBRT92M22G789R',2),--
    ('2024-04-01','MRNPLO81B11L567T',3),   
    ('2023-08-10','ELZCRL96T25A890P',2),  
    ('2023-12-25','JNCPDR94M03E345D',2),      
    ('2022-09-05','CPRTSN89L20G567F',1),--varese
    ('2023-09-05','CPRTSN89L20G567F',2),
    ('2023-04-05','FRNCSC76D14H890M',2),--venezia 
    ('2024-08-15','MRLRBN88A02L123P',3),   
    ('2024-08-28','ALBNCA83R25C456F',3),--padova
    ('2022-06-10','ALBNCA83R25C456F',2),--
    ('2022-09-20','GRTNLC91T10D789H',1),--verona
    ('2024-09-10','MRSRGM80E15M234N',3),  
    ('2023-10-05','FLBRCO86F11P567R',2),--varese
    ('2022-01-01','SLAPTR81M25L781D',1),
    ('2023-01-01','SLAPTR81M25L781D',2),
    ('2024-01-01','SLAPTR81M25L781D',3),
    ('2022-01-17','LLBRBR87L20E345S',1),--varese
    ('2023-01-19','LLBRBR87L20E345S',2),--
    ('2024-01-19','LLBRBR87L20E345S',3),--

    ('2022-04-04','MRLMNN93T14C890P',1),--pescara
    ('2023-06-03','MRLMNN93T14C890P',2),--
    ('2024-06-28','MRLMNN93T14C890P',3),--

    ('2022-05-09','FBNCCC79D11Z345M',1),--padova
    ('2023-05-11','FBNCCC79D11Z345M',2),--
    ('2024-05-17','FBNCCC79D11Z345M',3),--

    ('2022-06-15','NDCMRC94M25Y567D',1),--varese
    ('2023-06-15','NDCMRC94M25Y567D',2),--

    ('2023-01-08','PTRSSN88L03X890V',2),--pescara
    ('2024-01-08','PTRSSN88L03X890V',3),--

    ('2023-03-21','SMNRCH82A12K123B',2),--verona
    ('2024-03-21','SMNRCH82A12K123B',3),--

    ('2022-04-26','RMNTLC89R23G789T',1),--padova
    ('2023-04-26','RMNTLC89R23G789T',2)--
    ,
    ('2022-06-04','JNLMRC97M15L567X',1),--venezia
    ('2023-06-04','JNLMRC97M15L567X',2),--

    ('2023-06-22','ELNCRT85F14Z890N',2),--varese
    ('2023-08-07','FCMMLR80D22H567L',2),--varese
    ('2023-10-14','CMNMDA91R12F890S',2),--verona
    ('2023-12-19','GLNNCL84E05H567R',2),--venezia

    ('2024-01-27','ALBRGL78M10J890M',3),--varese
    ('2024-03-11','RVLLDE75A41E103P',3),--pescara
    ('2024-04-15','VLVGNO61S01L016X',3),--padova
    ('2024-05-22','VRNCRL95A30N890H',3);--venezia

    --insert for Cliente_Corso------------------------------------------
    insert into Cliente_Corso (Cliente,NomeCorso,EdizioneCorso,CittaPalestraCorso,IndirizzoPalestraCorso) values
    ('FRNCSC76D14H890M','Zumba',3,'Venezia','Località Martellago 130'),
    ('FRNCSC76D14H890M','Zumba',4,'Venezia','Località Martellago 130'),
    ('FRNCSC76D14H890M','Aqua Fitness',2,'Venezia','Località Martellago 130'),

    ('VRNCRL95A30N890H','Zumba',4,'Venezia','Località Martellago 130'),
    ('VRNCRL95A30N890H','Aqua Fitness',3,'Venezia','Località Martellago 130'),

    ('GLNNCL84E05H567R','Circuit Training',1,'Venezia','Località Martellago 130'),
    ('GLNNCL84E05H567R','Aqua Fitness',3,'Venezia','Località Martellago 130'),
    ('GLNNCL84E05H567R','Zumba',4,'Venezia','Località Martellago 130'),
    
    ('JNLMRC97M15L567X','Zumba',2,'Venezia','Località Martellago 130'),
    ('JNLMRC97M15L567X','Zumba',3,'Venezia','Località Martellago 130'),
    ('JNLMRC97M15L567X','Yoga',1,'Venezia','Località Martellago 130'),
    ('JNLMRC97M15L567X','Circuit Training',1,'Venezia','Località Martellago 130'),
    ('JNLMRC97M15L567X','Aqua Fitness',1,'Venezia','Località Martellago 130'),
    ('JNLMRC97M15L567X','Aqua Fitness',2,'Venezia','Località Martellago 130'),
    

    ('ALBNCA83R25C456F','Spinning',1,'Padova','Via Luzzatti 250'),
    ('ALBNCA83R25C456F','Functional Training',1,'Padova','Via Luzzatti 250'),
    ('ALBNCA83R25C456F','Boxe Fit',1,'Padova','Via Luzzatti 250'),
    ('ALBNCA83R25C456F','Spinning',4,'Padova','Via Luzzatti 250'),

    ('VLVGNO61S01L016X','Spinning',4,'Padova','Via Luzzatti 250'),
    ('VLVGNO61S01L016X','Functional Training',2,'Padova','Via Luzzatti 250'),

    ('RMNTLC89R23G789T','Zumba',1,'Padova','Via Luzzatti 250'),
    ('RMNTLC89R23G789T','Spinning',1,'Padova','Via Luzzatti 250'),
    ('RMNTLC89R23G789T','Spinning',2,'Padova','Via Luzzatti 250'),
    ('RMNTLC89R23G789T','Functional Training',2,'Padova','Via Luzzatti 250'),
    ('RMNTLC89R23G789T','Boxe Fit',2,'Padova','Via Luzzatti 250'),

    ('FBNCCC79D11Z345M','Zumba',1,'Padova','Via Luzzatti 250'),
    ('FBNCCC79D11Z345M','Spinning',2,'Padova','Via Luzzatti 250'),
    ('FBNCCC79D11Z345M','Spinning',3,'Padova','Via Luzzatti 250'),
    ('FBNCCC79D11Z345M','Spinning',4,'Padova','Via Luzzatti 250'),
    ('FBNCCC79D11Z345M','Functional Training',1,'Padova','Via Luzzatti 250'),
    ('FBNCCC79D11Z345M','Boxe Fit',1,'Padova','Via Luzzatti 250'),
    ('FBNCCC79D11Z345M','Boxe Fit',2,'Padova','Via Luzzatti 250'),


    ('GRTNLC91T10D789H','Pilates',2,'Verona','Via dell''Artigliere, 8'),
    ('GRTNLC91T10D789H','CrossFit',2,'Verona','Via dell''Artigliere, 8'),
    ('GRTNLC91T10D789H','CrossFit',3,'Verona','Via dell''Artigliere, 8'),

    ('ALBNCA83R25C456F','Zumba',1,'Verona','Via dell''Artigliere, 8'),
    ('ALBNCA83R25C456F','Pilates',1,'Verona','Via dell''Artigliere, 8'),
    ('ALBNCA83R25C456F','Pilates',2,'Verona','Via dell''Artigliere, 8'),
    ('ALBNCA83R25C456F','Calisthenics',2,'Verona','Via dell''Artigliere, 8'),
    ('ALBNCA83R25C456F','CrossFit',2,'Verona','Via dell''Artigliere, 8'),
    ('ALBNCA83R25C456F','CrossFit',3,'Verona','Via dell''Artigliere, 8'),

    ('CMNMDA91R12F890S','Calisthenics',1,'Verona','Via dell''Artigliere, 8'),
    ('CMNMDA91R12F890S','Calisthenics',2,'Verona','Via dell''Artigliere, 8'),
    ('CMNMDA91R12F890S','CrossFit',4,'Verona','Via dell''Artigliere, 8'),

    ('SMNRCH82A12K123B','Pilates',2,'Verona','Via dell''Artigliere, 8'),
    ('SMNRCH82A12K123B','Calisthenics',1,'Verona','Via dell''Artigliere, 8'),
    ('SMNRCH82A12K123B','Calisthenics',2,'Verona','Via dell''Artigliere, 8'),
    ('SMNRCH82A12K123B','CrossFit',4,'Verona','Via dell''Artigliere, 8'),


    ('ALEBRT92M22G789R','Stretching e Mobilità',1,'Pescara','Via Palmiro Togliatti'),
    ('ALEBRT92M22G789R','Zumba',1,'Pescara','Via Palmiro Togliatti'),
    ('ALEBRT92M22G789R','Zumba',2,'Pescara','Via Palmiro Togliatti'),
    ('ALEBRT92M22G789R','Total Body',2,'Pescara','Via Palmiro Togliatti'),
    ('ALEBRT92M22G789R','Power Yoga',1,'Pescara','Via Palmiro Togliatti'),

    ('RVLLDE75A41E103P','Total Body',2,'Pescara','Via Palmiro Togliatti'),

    ('PTRSSN88L03X890V','Zumba',1,'Pescara','Via Palmiro Togliatti'),
    ('PTRSSN88L03X890V','Zumba',2,'Pescara','Via Palmiro Togliatti'),
    ('PTRSSN88L03X890V','Stretching e Mobilità',1,'Pescara','Via Palmiro Togliatti'),
    ('PTRSSN88L03X890V','Total Body',1,'Pescara','Via Palmiro Togliatti'),
    ('PTRSSN88L03X890V','Total Body',2,'Pescara','Via Palmiro Togliatti'),
    ('PTRSSN88L03X890V','Ginnastica Posturale',1,'Pescara','Via Palmiro Togliatti'),
    
    ('MRLMNN93T14C890P','Zumba',1,'Pescara','Via Palmiro Togliatti'),
    ('MRLMNN93T14C890P','Zumba',2,'Pescara','Via Palmiro Togliatti'),
    ('MRLMNN93T14C890P','Total Body',1,'Pescara','Via Palmiro Togliatti'),
    ('MRLMNN93T14C890P','Total Body',2,'Pescara','Via Palmiro Togliatti'),
    ('MRLMNN93T14C890P','Ginnastica Posturale',2,'Pescara','Via Palmiro Togliatti'),
    ('MRLMNN93T14C890P','Power Yoga',1,'Pescara','Via Palmiro Togliatti'),
    
    
    ('CPRTSN89L20G567F','Zumba',2,'Varese','Piazza Garibaldi, 22'),
    ('CPRTSN89L20G567F','Zumba',3,'Varese','Piazza Garibaldi, 22'),
    ('CPRTSN89L20G567F','Functional Training',1,'Varese','Piazza Garibaldi, 22'),
    ('CPRTSN89L20G567F','Functional Training',2,'Varese','Piazza Garibaldi, 22'),
    ('CPRTSN89L20G567F','Functional Training',3,'Varese','Piazza Garibaldi, 22'),
    ('CPRTSN89L20G567F','Calisthenics',1,'Varese','Piazza Garibaldi, 22'),

    ('FCMMLR80D22H567L','Calisthenics',1,'Varese','Piazza Garibaldi, 22'),
    ('FCMMLR80D22H567L','Pilates',1,'Varese','Piazza Garibaldi, 22'),
    ('FCMMLR80D22H567L','Functional Training',3,'Varese','Piazza Garibaldi, 22'),

    ('ALBRGL78M10J890M','Zumba',3,'Varese','Piazza Garibaldi, 22'),
    ('ALBRGL78M10J890M','Pilates',1,'Varese','Piazza Garibaldi, 22'),
    ('ALBRGL78M10J890M','Functional Training',3,'Varese','Piazza Garibaldi, 22'),
    ('ALBRGL78M10J890M','Functional Training',4,'Varese','Piazza Garibaldi, 22'),

    ('FLBRCO86F11P567R','Calisthenics',1,'Varese','Piazza Garibaldi, 22'),
    ('FLBRCO86F11P567R','Yoga',2,'Varese','Piazza Garibaldi, 22'),
    ('FLBRCO86F11P567R','Pilates',1,'Varese','Piazza Garibaldi, 22'),

    ('ELNCRT85F14Z890N','Zumba',2,'Varese','Piazza Garibaldi, 22'),
    ('ELNCRT85F14Z890N','Zumba',3,'Varese','Piazza Garibaldi, 22'),
    ('ELNCRT85F14Z890N','Yoga',2,'Varese','Piazza Garibaldi, 22'),

    ('LLBRBR87L20E345S','Zumba',1,'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Zumba',2,'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Zumba',3,'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Spinning',1, 'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Spinning',2, 'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Pilates',1,'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Functional Training',1,'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Functional Training',2,'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Functional Training',3,'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Functional Training',4,'Varese','Piazza Garibaldi, 22'),
    ('LLBRBR87L20E345S','Calisthenics',1,'Varese','Piazza Garibaldi, 22'),

    ('NDCMRC94M25Y567D','Zumba',1, 'Varese','Piazza Garibaldi, 22'),
    ('NDCMRC94M25Y567D','Zumba',2, 'Varese','Piazza Garibaldi, 22'),
    ('NDCMRC94M25Y567D','Zumba',3, 'Varese','Piazza Garibaldi, 22'),
    ('NDCMRC94M25Y567D','Spinning',1, 'Varese','Piazza Garibaldi, 22'),
    ('NDCMRC94M25Y567D','Spinning',2, 'Varese','Piazza Garibaldi, 22'),
    ('NDCMRC94M25Y567D','Functional Training',1, 'Varese','Piazza Garibaldi, 22'),
    ('NDCMRC94M25Y567D','Functional Training',3, 'Varese','Piazza Garibaldi, 22');

    --insert for Esercizio_gruppomuscolare------------
    insert into Esercizio_gruppomuscolare (Esercizio,GruppoMuscolare) values
    ('Dip alle parallele','Pettorali'),
    ('Dip alle parallele','Tricipiti'),
    ('Pulley basso triangolo','Dorsali'),
    ('Pulley basso triangolo','Trapezi'),
    ('Trazioni presa prona','Dorsali'),
    ('Trazioni presa prona','Bicipiti'),
    ('Squat bilanciere','Quadricipiti'),
    ('Squat bilanciere','Glutei'),
    ('Shoulder press','Spalle'),
    ('Shoulder press','Tricipiti'),
    ('Gatto','Stretching'),
    ('Plank','Addominali'),
    ('Calf in piedi su rialzo bilanciere','Polpacci'),
    ('Rematore in piedi bilanciere','Dorsali'),
    ('Push up','Pettorali'),
    ('Leg curl','Femorali'),
    ('Curl in piedi cavo basso con sbarra','Bicipiti'),
    ('Tapis roulant','Cardio'),
    ('French press bilanciere panca piana','Tricipiti'),
    ('Curl 2 manubri in piedi','Bicipiti'),
    ('Alzate gamba su fianco a terra','Abduttori'),
    ('Alzate laterali singolo cavo in piedi','Spalle'),
    ('Chiusure seduto adductor machine','Addutori'),
    ('Aperture peck back','Trapezi'),
    ('Leg extension', 'Quadricipiti'),
    ('Leg extension', 'Femorali'),
    ('Lat pulldown', 'Dorsali'),
    ('Lat pulldown', 'Bicipiti'),
    ('Crunch', 'Addominali'),
    ('Deadlift', 'Dorsali'),
    ('Deadlift', 'Glutei'),
    ('Bench press', 'Pettorali'),
    ('Bench press', 'Tricipiti'),
    ('Hammer curl', 'Bicipiti'),
    ('Leg press', 'Quadricipiti'),
    ('Leg press', 'Glutei'),
    ('Calf raise', 'Polpacci'),
    ('Military press', 'Spalle'),
    ('Military press', 'Tricipiti'),
    ('Dumbbell flyes', 'Pettorali'),
    ('Lunges', 'Femorali'),
    ('Lunges', 'Glutei'),
    ('Bent-over rows', 'Dorsali'),
    ('Bent-over rows', 'Bicipiti'),
    ('Flessioni tricipiti', 'Tricipiti'),
    ('Stacco rumeno', 'Femorali'),
    ('Squat sumo', 'Quadricipiti'),
    ('Pressa Arnold', 'Spalle'),
    ('Rematore al cavo', 'Dorsali'),
    ('Plank laterale', 'Addominali'),
    ('Russian twists', 'Addominali'),
    ('Curl femorali seduto', 'Femorali'),
    ('Dumbbell pullover', 'Pettorali'),
    ('Alzate laterali', 'Spalle'),
    ('Trazione inversa', 'Trapezi'),
    ('Alzate posteriori', 'Spalle'),
    ('Estensioni per tricipiti', 'Tricipiti'),
    ('Rematore seduto al cavo basso', 'Dorsali'),
    ('Squat frontale', 'Quadricipiti'),
    ('Ponte glutei', 'Glutei'),
    ('Leg curl seduto', 'Femorali'),
    ('Curl martello', 'Bicipiti'),
    ('Squat bulgaro', 'Quadricipiti'),
    ('Pressa spalle', 'Spalle'),
    ('Curl concentrato', 'Bicipiti'),
    ('Tritonatori tricipiti', 'Tricipiti'),
    ('Good morning', 'Femorali'),
    ('Addominali crunch su fitball', 'Addominali'),
    ('Curl femorali in piedi', 'Femorali'),
    ('Push up sulle ginocchia', 'Pettorali'),
    ('Estensioni tricipiti al cavo', 'Tricipiti'),
    ('Leg curl a 45 gradi', 'Femorali'),
    ('Affondi', 'Quadricipiti'),
    ('Clean and press', 'Spalle'),
    ('Dorsali pull over', 'Dorsali'),
    ('Squat goblet', 'Quadricipiti'),
    ('Estensioni per tricipiti al cavo alto', 'Tricipiti'),
    ('Stacchi rumeni su panca', 'Femorali'),
    ('Crunch inverso', 'Addominali'),
    ('Bent-over lateral raise', 'Dorsali'),
    ('Squat hack', 'Quadricipiti'),
    ('Shoulder press con manubri', 'Spalle'),
    ('Reverse crunch', 'Addominali'),
    ('Trazioni alla sbarra', 'Dorsali'),
    ('Leg curl a 90 gradi', 'Femorali'),
    ('Curl con manubri in supinazione', 'Bicipiti'),
    ('Leg press orizzontale', 'Quadricipiti'),
    ('Sollevamento laterale con manubri', 'Spalle'),
    ('Plank laterale con sollevamento gamba', 'Addominali'),
    ('Pulley alto', 'Dorsali'),
    ('Squat bulgaro con manubri', 'Quadricipiti'),
    ('French press con manubri', 'Tricipiti'),
    ('Reverse hyperextension', 'Glutei');

    --insert for Esercizio_Scheda
    insert into Esercizio_Scheda (Scheda,Esercizio,SerieRipetizioni,TempoRecupero) values
    (1,'Trazione inversa','2x10','1:30'),
    (1,'French press con manubri','3x15','1:10'),
    (1,'Squat goblet','3x15','1:30'),
    (1,'Alzate laterali','5x5','2:00'),
    (1,'Leg curl a 90 gradi','5x5','1:30'),
    (1,'Leg curl','2x15','1:30'),
    (1,'Alzate laterali singolo cavo in piedi','4x8','1:00'),
    (1,'Aperture peck back','3x10','1:00'),
    (1,'Curl concentrato','4x8','1:30'),
    (1,'Dumbbell flyes','3xmassime','1:20'),
    (1,'Squat sumo','2x15','2:00'),
    
    (2,'Leg curl a 90 gradi','2x10','2:00'),
    (2,'Squat bilanciere','5x5','1:00'),
    (2,'Curl martello','3x8','1:00'),
    (2,'Leg curl','3x15','1:00'),
    (2,'Lunges','4x10','1:00'),
    (2,'Rematore in piedi bilanciere','3xmassime','1:20'),
    (2,'Squat goblet','3x10','1:00'),
    (2,'Stacco rumeno','3x8','1:10'),
    (2,'Crunch inverso','3x15','1:10'),
    (2,'Alzate laterali singolo cavo in piedi','3x15','1:00'),
    (2,'Extrarotazioni stile l in piedi elastico','3x10','1:10'),
    (2,'Squat hack','3xmassime','1:00'),
    (2,'Aperture peck back','3x8','1:00'),
    
    (3,'Curl femorali seduto','3x15','1:20'),
    (3,'Curl con manubri in supinazione','3x8','1:10'),
    (3,'Leg press','5x5','2:00'),
    (3,'Leg curl a 90 gradi','2x15','2:00'),
    (3,'Push up sulle ginocchia','4x8','1:00'),
    (3,'Estensioni per tricipiti','3x10','1:10'),
    (3,'Crunch inverso','4x8','1:20'),
    (3,'Curl in piedi cavo basso con sbarra','2x10','1:30'),
    (3,'Alzate posteriori','3x8','2:00'),
    (3,'Rematore in piedi bilanciere','3x10','1:00'),
    
    (4,'Chiusure seduto adductor machine','3x15','1:00'),
    (4,'Dorsali pull over','2x10','1:30'),
    (4,'Alzate laterali','4x10','1:00'),
    (4,'Affondi','4x8','1:20'),
    (4,'Pressa spalle','5x5','1:00'),
    (4,'Alzate gamba su fianco a terra','5x5','1:00'),
    (4,'Sollevamento laterale con manubri','3x10','1:30'),
    (4,'Plank laterale','4x8','1:00'),
    (4,'Military press','3x15','1:10'),
    (4,'Curl 2 manubri in piedi','4x8','1:20'),
    (4,'Trazioni alla sbarra','3x10','1:20'),
    (4,'Deadlift','2x15','1:30'),
    (4,'Squat bulgaro con manubri','4x8','1:10'),
    (4,'Plank laterale con sollevamento gamba','4x10','1:00'),
    (4,'Rematore seduto al cavo basso','5x5','1:10'),
    (4,'Lat pulldown','3x8','2:00'),
    (4,'Push up','3x8','1:10'),
    (4,'Leg curl seduto','3xmassime','1:00'),
    (4,'Leg curl a 90 gradi','3xmassime','1:10'),
    
    (5,'Plank laterale con sollevamento gamba','4x8','1:20'),
    (5,'Bench press','3xmassime','2:00'),
    (5,'Squat hack','5x5','1:30'),
    (5,'Leg press orizzontale','3x10','1:30'),
    (5,'Extrarotazioni stile l in piedi elastico','3x15','1:30'),
    (5,'Lat pulldown','2x10','1:30'),
    (5,'Addominali crunch su fitball','3xmassime','1:00'),
    (5,'Alzate posteriori','3x8','1:30'),
    (5,'Leg curl a 45 gradi','2x10','1:20'),
    (5,'Rematore in piedi bilanciere','3xmassime','1:00'),
    (5,'Leg curl','5x5','1:30'),
    (5,'Trazioni presa prona','3x15','1:20'),
    (5,'Leg extension','3xmassime','1:30'),
    (5,'Clean and press','3x10','1:00'),
    (5,'Tapis roulant','4x10','1:10'),
    (5,'Squat frontale','3x10','1:20'),
    (5,'Pulley basso triangolo','3x15','1:20'),
    (5,'Chiusure seduto adductor machine','4x10','1:20'),
    (5,'Alzate laterali in piedi manubri','3x8','2:00'),
    (5,'Chest press','2x10','2:00'),
    
    (6,'Reverse crunch','3x10','2:00'),
    (6,'Curl 2 manubri in piedi','3xmassime','1:30'),
    (6,'Clean and press','4x10','1:10'),
    (6,'Gatto','2x10','1:20'),
    (6,'Squat bulgaro con manubri','3x10','1:20'),
    (6,'Extrarotazioni stile l in piedi elastico','3xmassime','1:30'),
    (6,'Sollevamento laterale con manubri','2x10','1:30'),
    (6,'Chest press','3x15','1:00'),
    (6,'Trazione inversa','3x15','2:00'),
    (6,'Lat pulldown','3x10','2:00'),
    (6,'Aperture peck back','4x10','2:00'),
    (6,'Addominali crunch su fitball','2x10','2:00'),
    (6,'Alzate laterali','2x10','1:00'),
    (6,'Rematore seduto al cavo basso','3xmassime','1:20'),
    (6,'Curl femorali in piedi','3x8','1:30'),
    (6,'Push up','2x10','1:30'),
    (6,'Leg press orizzontale','4x10','1:10'),
    
    (7,'Squat goblet','4x10','1:10'),
    (7,'Chest press','4x8','1:30'),
    (7,'Panca piana bilanciere','3x10','1:00'),
    (7,'Leg curl a 45 gradi','2x10','2:00'),
    (7,'Stacco rumeno','5x5','1:20'),
    (7,'Extrarotazioni stile l in piedi elastico','4x8','1:30'),
    (7,'Military press','4x10','1:00'),
    (7,'Push up','2x10','1:30'),
    (7,'Ponte glutei','3x15','1:10'),
    (7,'Bench press','3x15','1:20'),
    (7,'Russian twists','3x8','1:00'),
    (7,'Leg press orizzontale','2x10','1:30'),
    (7,'Alzate gamba su fianco a terra','2x10','1:10'),
    (7,'Leg extension','2x10','1:10'),
    (7,'Estensioni per tricipiti','2x10','1:30'),
    
    (8,'Squat frontale','2x15','2:00'),
    (8,'Reverse hyperextension','4x8','1:10'),
    (8,'Shoulder press con manubri','4x8','2:00'),
    (8,'Bent-over rows','2x15','1:30'),
    (8,'Trazione inversa','3x15','1:10'),
    (8,'Squat bulgaro con manubri','3xmassime','1:30'),
    (8,'Plank laterale con sollevamento gamba','5x5','1:30'),
    (8,'Curl in piedi cavo basso con sbarra','3x8','1:00'),
    (8,'Lat pulldown','3x15','1:30'),
    (8,'Russian twists','4x10','1:30'),
    
    (9,'Dip alle parallele','2x15','1:10'),
    (9,'Leg curl a 90 gradi','3x10','1:10'),
    (9,'Squat bilanciere','2x10','1:30'),
    (9,'Pulley alto','3x15','2:00'),
    (9,'Trazioni alla sbarra','3xmassime','1:30'),
    (9,'Hammer curl','2x10','1:30'),
    (9,'Crunch','2x10','1:00'),
    (9,'Lat machine avanti','2x15','1:00'),
    (9,'Leg curl','3x10','1:30'),
    (9,'Leg press','5x5','1:10'),
    (9,'Dumbbell flyes','4x10','2:00'),
    (9,'Calf raise','4x8','1:20'),
    (9,'Trazioni presa prona','3x8','1:00'),
    (9,'Alzate laterali singolo cavo in piedi','4x8','1:10'),
    (9,'Shoulder press','4x10','1:20'),
    (9,'Curl martello','3x10','1:30'),
    (9,'Pressa Arnold','4x8','1:10'),
    (9,'Rematore al cavo','4x10','1:00'),
    
    (10,'Curl femorali in piedi','5x5','1:00'),
    (10,'Good morning','3x10','1:30'),
    (10,'Curl 2 manubri in piedi','3x15','1:20'),
    (10,'Squat hack','4x10','1:30'),
    (10,'Pulley basso triangolo','3x10','1:00'),
    (10,'Leg curl a 90 gradi','3x15','1:00'),
    (10,'Lat pulldown','4x8','1:30'),
    (10,'Plank','3x8','2:00'),
    (10,'Aperture peck back','2x15','2:00'),
    (10,'Estensioni tricipiti al cavo','3x10','2:00'),
    (10,'Lunges','5x5','1:00'),
    (10,'Squat bulgaro con manubri','4x8','1:00'),
    (10,'Chest press','2x15','1:30'),
    (10,'Panca inclinata manubri','3x10','2:00'),
    (10,'Stacco rumeno','3xmassime','1:30'),
    (10,'Trazione inversa','3x8','1:10'),
    
    (11,'Bench press','2x10','1:00'),
    (11,'Ponte glutei','3xmassime','1:00'),
    (11,'Bent-over rows','3x15','1:30'),
    (11,'Plank','4x8','1:00'),
    (11,'Curl martello','3x15','2:00'),
    (11,'Military press','3x8','1:30'),
    (11,'Pulley alto','3x10','2:00'),
    (11,'Lunges','2x10','1:00'),
    (11,'Addominali crunch su fitball','2x10','1:20'),
    (11,'Rematore in piedi bilanciere','3x8','1:30'),
    (11,'Leg extension','5x5','1:10'),
    (11,'Pulley basso triangolo','4x8','1:30'),
    (11,'Curl in piedi bilanciere','4x8','1:30'),
    (11,'Squat bulgaro con manubri','3x10','1:20'),
    (11,'Squat bilanciere','3x15','1:20'),
    
    (12,'Plank laterale','2x15','1:20'),
    (12,'Chest press','2x15','1:20'),
    (12,'Good morning','3x15','1:30'),
    (12,'Deadlift','3x15','1:20'),
    (12,'Reverse crunch','4x10','1:10'),
    (12,'Leg curl a 45 gradi','4x10','2:00'),
    (12,'Dip alle parallele','2x15','1:00'),
    (12,'Alzate laterali in piedi manubri','3x15','1:10'),
    (12,'Alzate laterali singolo cavo in piedi','5x5','1:20'),
    (12,'Estensioni per tricipiti al cavo alto','4x8','2:00'),
    (12,'Leg press','3x15','1:30'),
    (12,'Curl 2 manubri in piedi','2x10','1:30'),
    (12,'Leg curl seduto','2x15','1:10'),
    (12,'Crunch','2x15','1:10'),
    
    (13,'Calf raise','5x5','2:00'),
    (13,'Trazione inversa','3x8','1:20'),
    (13,'Tritonatori tricipiti','2x15','1:20'),
    (13,'French press bilanciere panca piana','3x15','1:10'),
    (13,'Addominali crunch su fitball','5x5','2:00'),
    (13,'Bench press','4x10','1:00'),
    (13,'Bent-over lateral raise','2x15','1:10'),
    (13,'Chiusure seduto adductor machine','2x10','1:30'),
    (13,'Estensioni per tricipiti al cavo alto','3x15','1:00'),
    (13,'Trazioni alla sbarra','5x5','1:00'),
    (13,'Rematore al cavo','3x8','1:00'),
    (13,'Military press','3x8','1:10'),
    
    (14,'Alzate laterali singolo cavo in piedi','2x15','1:30'),
    (14,'Pulley alto','2x15','2:00'),
    (14,'Trazioni presa prona','4x10','1:00'),
    (14,'Bent-over rows','3x15','2:00'),
    (14,'Reverse crunch','3x15','2:00'),
    (14,'Leg extension','3xmassime','1:20'),
    (14,'Calf raise','5x5','1:20'),
    (14,'Plank laterale','2x10','1:10'),
    (14,'French press con manubri','2x15','2:00'),
    (14,'Tapis roulant','2x10','1:20'),
    
    (15,'Pressa spalle','4x10','1:10'),
    (15,'Squat bilanciere','2x10','1:00'),
    (15,'Dumbbell flyes','2x15','1:10'),
    (15,'Clean and press','3xmassime','1:10'),
    (15,'French press bilanciere panca piana','3x10','1:30'),
    (15,'Alzate laterali','3x8','1:00'),
    (15,'Aperture peck back','2x10','1:10'),
    (15,'Estensioni per tricipiti al cavo alto','2x10','1:30'),
    (15,'Lat pulldown','4x8','1:00'),
    (15,'Estensioni tricipiti al cavo','4x8','2:00'),
    (15,'Shoulder press','3x8','1:20'),
    (15,'Pulley alto','3x15','1:20'),
    
    (16,'Pressa spalle','5x5','1:10'),
    (16,'Trazione inversa','5x5','1:20'),
    (16,'Chest press','3xmassime','1:30'),
    (16,'Addominali crunch su fitball','4x8','1:10'),
    (16,'Pulley basso triangolo','3x8','2:00'),
    (16,'Reverse hyperextension','2x10','2:00'),
    (16,'Panca inclinata manubri','3xmassime','2:00'),
    (16,'Trazioni presa prona','3x8','1:00'),
    (16,'Aperture peck back','3x8','1:20'),
    (16,'Dip alle parallele','2x10','2:00'),
    (16,'Alzate laterali singolo cavo in piedi','3x15','1:10'),
    
    (17,'Push up sulle ginocchia','2x15','2:00'),
    (17,'Alzate gamba su fianco a terra','5x5','1:20'),
    (17,'Lunges','5x5','1:00'),
    (17,'Estensioni tricipiti al cavo','2x15','1:10'),
    (17,'Curl martello','3x10','1:00'),
    (17,'Calf in piedi su rialzo bilanciere','4x10','1:00'),
    (17,'Reverse hyperextension','2x10','2:00'),
    (17,'Leg curl a 90 gradi','3xmassime','1:30'),
    (17,'Crunch inverso','4x8','2:00'),
    (17,'Aperture peck back','4x10','2:00'),
    (17,'French press con manubri','3x15','1:20'),
    (17,'Tritonatori tricipiti','5x5','1:20'),
    (17,'Military press','2x10','1:30'),
    
    (18,'Plank laterale','3x15','1:00'),
    (18,'Stacco rumeno','3x8','1:10'),
    (18,'Calf raise','5x5','2:00'),
    (18,'Shoulder press','3xmassime','1:20'),
    (18,'Push up','4x10','1:00'),
    (18,'Leg curl a 45 gradi','5x5','2:00'),
    (18,'Crunch inverso','3x10','1:10'),
    (18,'Trazione inversa','3x10','1:10'),
    (18,'Leg curl','3xmassime','1:00'),
    (18,'Push up sulle ginocchia','2x15','1:00'),
    (18,'Calf in piedi su rialzo bilanciere','2x10','1:20'),
    
    (19,'Squat hack','2x15','1:30'),
    (19,'Reverse crunch','2x15','1:30'),
    (19,'Estensioni per tricipiti','2x15','2:00'),
    (19,'Trazioni alla sbarra','2x10','1:00'),
    (19,'Tritonatori tricipiti','2x10','1:20'),
    (19,'Flessioni tricipiti','5x5','1:30'),
    (19,'Alzate laterali singolo cavo in piedi','5x5','2:00'),
    (19,'Curl concentrato','2x10','1:10'),
    (19,'Curl con manubri in supinazione','3x8','1:20'),
    (19,'Curl femorali seduto','3x8','1:10'),
    (19,'Shoulder press','3x10','1:00'),
    (19,'Chest press','5x5','1:00'),
    (19,'Tapis roulant','3x15','1:10'),
    (19,'Lunges','3x15','1:00'),
    (19,'Shoulder press con manubri','2x10','1:20'),
    (19,'Calf in piedi su rialzo bilanciere','2x15','1:00'),
    (19,'Squat frontale','3x15','1:00'),
    (19,'Good morning','3xmassime','2:00'),
    
    (20,'Clean and press','2x15','1:30'),
    (20,'Military press','4x8','2:00'),
    (20,'Lat pulldown','4x8','1:20'),
    (20,'Plank','3xmassime','1:00'),
    (20,'French press con manubri','2x10','1:20'),
    (20,'Pressa Arnold','3x10','1:20'),
    (20,'Plank laterale','3xmassime','1:00'),
    (20,'Alzate laterali in piedi manubri','5x5','1:20'),
    (20,'Chiusure seduto adductor machine','5x5','1:30'),
    (20,'Good morning','2x10','1:10'),
    (20,'Leg curl a 45 gradi','5x5','1:00'),
    
    (21,'Dip alle parallele','3x10','2:00'),
    (21,'Squat bilanciere','4x10','1:00'),
    (21,'Calf raise','3x8','1:10'),
    (21,'Dorsali pull over','5x5','2:00'),
    (21,'Trazione inversa','3x8','1:00'),
    (21,'Plank laterale','4x10','1:30'),
    (21,'Clean and press','3x10','2:00'),
    (21,'Alzate laterali singolo cavo in piedi','4x8','1:20'),
    (21,'Squat hack','5x5','1:00'),
    (21,'Curl in piedi bilanciere','3x8','1:00'),
    (21,'Russian twists','4x10','1:00'),
    (21,'Plank','3x8','1:10'),
    (21,'Trazioni alla sbarra','2x15','1:20'),
    (21,'Bent-over lateral raise','2x10','1:00'),
    
    (22,'Good morning','3xmassime','1:00'),
    (22,'Leg curl a 45 gradi','3x15','1:00'),
    (22,'Russian twists','4x8','1:20'),
    (22,'Estensioni per tricipiti al cavo alto','2x15','1:20'),
    (22,'Military press','2x10','1:00'),
    (22,'Alzate laterali singolo cavo in piedi','2x10','1:20'),
    (22,'Affondi','3x10','1:10'),
    (22,'Plank laterale con sollevamento gamba','3x8','2:00'),
    (22,'Alzate laterali in piedi manubri','4x10','1:30'),
    (22,'Bench press','4x8','1:00'),
    (22,'Sollevamento laterale con manubri','4x8','1:00'),
    
    (23,'Calf in piedi su rialzo bilanciere','4x10','1:20'),
    (23,'Leg extension','2x15','1:30'),
    (23,'Dumbbell flyes','2x15','1:00'),
    (23,'Alzate posteriori','2x10','2:00'),
    (23,'Bench press','4x10','1:30'),
    (23,'Estensioni per tricipiti al cavo alto','2x10','1:30'),
    (23,'Panca inclinata manubri','3x8','2:00'),
    (23,'Curl femorali seduto','4x10','1:10'),
    (23,'Reverse crunch','3xmassime','1:10'),
    (23,'Leg press','4x10','2:00'),
    (23,'Curl concentrato','3x10','2:00'),
    (23,'Lunges','2x15','1:00'),
    (23,'Chest press','4x10','2:00'),
    
    (24,'Dorsali pull over','3x10','1:10'),
    (24,'Push up sulle ginocchia','5x5','1:10'),
    (24,'Pressa spalle','3xmassime','1:30'),
    (24,'Reverse hyperextension','2x15','1:30'),
    (24,'Calf in piedi su rialzo bilanciere','4x10','1:00'),
    (24,'Chiusure seduto adductor machine','3x15','1:10'),
    (24,'Plank','3x8','2:00'),
    (24,'Bent-over rows','3xmassime','1:00'),
    (24,'Crunch','4x8','1:20'),
    (24,'Squat hack','3x10','1:20'),
    (24,'French press bilanciere panca piana','2x15','1:00'),
    (24,'Deadlift','4x8','1:20'),
    (24,'Clean and press','2x15','1:00'),
    (24,'Curl martello','2x10','2:00'),
    (24,'Shoulder press con manubri','4x8','2:00'),
    
    (25,'Clean and press','3x15','1:10'),
    (25,'Plank','5x5','1:30'),
    (25,'Extrarotazioni stile l in piedi elastico','4x10','2:00'),
    (25,'Tritonatori tricipiti','4x8','1:30'),
    (25,'Gatto','3xmassime','1:00'),
    (25,'Curl in piedi bilanciere','2x10','1:00'),
    (25,'Panca piana bilanciere','3x10','1:10'),
    (25,'Curl femorali seduto','2x10','2:00'),
    (25,'Curl con manubri in supinazione','4x8','1:20'),
    (25,'Shoulder press con manubri','2x15','2:00'),
    (25,'Calf in piedi su rialzo bilanciere','3x15','1:00'),
    (25,'Leg curl a 45 gradi','3x10','2:00'),
    (25,'Alzate laterali in piedi manubri','3x15','1:00'),
    (25,'Affondi','4x10','2:00'),
    (25,'Pressa Arnold','3x8','1:10'),
    (25,'Chiusure seduto adductor machine','2x15','1:20'),
    (25,'Squat sumo','3x15','1:00'),
    
    (26,'Dorsali pull over','4x8','1:00'),
    (26,'Curl martello','4x8','1:10'),
    (26,'Good morning','4x8','1:00'),
    (26,'Gatto','3x8','1:30'),
    (26,'Squat goblet','2x10','1:00'),
    (26,'Extrarotazioni stile l in piedi elastico','2x15','1:10'),
    (26,'Calf raise','3x15','2:00'),
    (26,'Curl con manubri in supinazione','3x8','1:10'),
    (26,'French press bilanciere panca piana','2x10','1:10'),
    (26,'Clean and press','2x10','2:00'),
    (26,'Russian twists','3x10','1:00'),
    (26,'Alzate laterali','3x15','2:00'),
    (26,'Calf in piedi su rialzo bilanciere','3x10','1:10'),
    (26,'Estensioni per tricipiti','5x5','1:10'),
    (26,'Pressa spalle','3x8','1:20'),
    
    (27,'Estensioni per tricipiti','3x10','1:20'),
    (27,'Curl concentrato','2x10','1:10'),
    (27,'Aperture peck back','3xmassime','1:20'),
    (27,'Gatto','3x10','1:30'),
    (27,'Alzate laterali in piedi manubri','4x8','1:00'),
    (27,'Leg extension','5x5','1:10'),
    (27,'Stacchi rumeni su panca','2x10','1:10'),
    (27,'Alzate posteriori','4x10','1:00'),
    (27,'Bent-over lateral raise','4x8','2:00'),
    (27,'Push up sulle ginocchia','3x10','1:20'),
    (27,'Leg press','3xmassime','1:10'),
    (27,'French press con manubri','2x15','1:30'),
    (27,'Leg curl a 90 gradi','2x10','1:00'),
    (27,'Lat machine avanti','4x10','1:00'),
    (27,'Plank laterale','5x5','1:30'),
    (27,'Dumbbell flyes','3xmassime','1:10'),
    (27,'Leg press orizzontale','3x10','2:00'),
    (27,'Alzate laterali','2x15','2:00'),
    (27,'Curl martello','5x5','1:00'),
    
    (28,'Squat hack','3x8','1:20'),
    (28,'Tapis roulant','4x10','1:20'),
    (28,'Leg press orizzontale','3x15','2:00'),
    (28,'Leg curl','5x5','1:30'),
    (28,'Leg extension','3x8','1:30'),
    (28,'Deadlift','4x8','1:00'),
    (28,'Estensioni per tricipiti','2x10','1:10'),
    (28,'Ponte glutei','5x5','1:00'),
    (28,'Pressa spalle','3xmassime','2:00'),
    (28,'Curl femorali in piedi','3xmassime','1:10'),
    (28,'Panca piana bilanciere','3x10','2:00'),
    (28,'Plank laterale','5x5','1:00'),
    (28,'Alzate laterali','4x8','1:20'),
    (28,'Calf in piedi su rialzo bilanciere','5x5','1:00'),
    (28,'Addominali crunch su fitball','4x10','1:30'),
    (28,'Alzate laterali singolo cavo in piedi','4x8','1:00'),
    
    (29,'Trazioni alla sbarra','3x10','1:20'),
    (29,'Trazione inversa','2x15','1:00'),
    (29,'Dumbbell pullover','3xmassime','1:00'),
    (29,'Alzate laterali','3xmassime','1:00'),
    (29,'Calf in piedi su rialzo bilanciere','4x8','1:00'),
    (29,'Military press','4x8','2:00'),
    (29,'Curl in piedi bilanciere','4x8','1:10'),
    (29,'Shoulder press con manubri','5x5','1:10'),
    (29,'Leg press orizzontale','3x10','1:00'),
    (29,'Clean and press','3x15','2:00'),
    (29,'Rematore in piedi bilanciere','3x10','1:10'),
    (29,'Crunch inverso','5x5','2:00'),
    (29,'Push up','4x10','1:30'),
    (29,'Plank laterale con sollevamento gamba','3xmassime','1:20'),
    (29,'Gatto','5x5','1:20'),
    
    (30,'Rematore in piedi bilanciere','3x10','1:20'),
    (30,'Leg extension','5x5','1:00'),
    (30,'Squat bulgaro con manubri','3x15','1:10'),
    (30,'Plank laterale','4x10','1:30'),
    (30,'Curl con manubri in supinazione','3x10','1:20'),
    (30,'Lunges','3xmassime','1:30'),
    (30,'Good morning','3x8','1:10'),
    (30,'Alzate laterali','2x10','1:20'),
    (30,'Leg curl a 90 gradi','2x10','1:00'),
    (30,'Estensioni per tricipiti','3xmassime','2:00'),
    (30,'Pressa spalle','3x8','1:00'),
    (30,'Chiusure seduto adductor machine','5x5','1:30'),
    (30,'Hammer curl','2x15','2:00'),
    (30,'Crunch inverso','5x5','2:00'),
    (30,'Curl martello','3x8','1:10'),
    (30,'Squat frontale','3x8','1:20'),
    (30,'Plank','5x5','1:10'),
    (30,'Alzate posteriori','4x10','1:00'),
    (30,'Squat bulgaro','5x5','1:00'),
    (30,'Tritonatori tricipiti','3xmassime','1:30'),
    
    (31,'Pressa Arnold','3x8','1:20'),
    (31,'Rematore seduto al cavo basso','5x5','1:00'),
    (31,'Push up sulle ginocchia','3x10','1:00'),
    (31,'Squat bilanciere','4x8','1:30'),
    (31,'Plank laterale con sollevamento gamba','4x10','1:10'),
    (31,'Military press','3x10','1:10'),
    (31,'Crunch inverso','5x5','2:00'),
    (31,'Dumbbell flyes','3xmassime','2:00'),
    (31,'Rematore in piedi bilanciere','3x10','1:00'),
    (31,'Stacco rumeno','3x15','1:30'),
    (31,'Pulley basso triangolo','3x10','1:00'),
    (31,'Calf raise','3x15','1:00'),
    (31,'Leg curl a 90 gradi','3x10','2:00'),
    (31,'French press bilanciere panca piana','4x8','1:20'),
    (31,'Reverse crunch','2x10','1:10'),
    
    (32,'Tapis roulant','3x15','1:30'),
    (32,'Leg curl seduto','5x5','1:00'),
    (32,'Curl 2 manubri in piedi','2x10','1:00'),
    (32,'Dumbbell pullover','2x10','1:00'),
    (32,'Curl femorali in piedi','3xmassime','1:30'),
    (32,'Chiusure seduto adductor machine','3x15','1:30'),
    (32,'Dip alle parallele','3x8','1:00'),
    (32,'Tritonatori tricipiti','2x10','2:00'),
    (32,'Panca inclinata manubri','3x8','1:00'),
    (32,'Pressa spalle','4x10','1:10'),
    (32,'Dorsali pull over','3x10','1:20'),
    (32,'Stacchi rumeni su panca','2x15','1:00'),
    (32,'Ponte glutei','4x10','1:30'),
    (32,'Estensioni per tricipiti al cavo alto','3x15','1:00'),
    (32,'Bench press','3x15','2:00'),
    
    (33,'Stacco rumeno','3x15','1:00'),
    (33,'Squat sumo','3x15','2:00'),
    (33,'Curl concentrato','3xmassime','2:00'),
    (33,'Alzate laterali singolo cavo in piedi','2x10','2:00'),
    (33,'Estensioni per tricipiti al cavo alto','4x10','1:20'),
    (33,'Bent-over lateral raise','4x8','2:00'),
    (33,'Pulley basso triangolo','4x8','1:00'),
    (33,'Bench press','4x8','1:10'),
    (33,'Flessioni tricipiti','4x10','1:20'),
    (33,'Curl femorali in piedi','3x8','1:20'),
    (33,'Hammer curl','3x15','1:30'),
    (33,'Leg curl seduto','2x15','1:00'),
    (33,'Squat hack','3x10','1:10'),
    (33,'Calf in piedi su rialzo bilanciere','3x10','1:10'),
    
    (34,'Plank laterale con sollevamento gamba','3x8','1:30'),
    (34,'French press bilanciere panca piana','3x8','1:10'),
    (34,'Leg press','3xmassime','1:20'),
    (34,'Clean and press','2x15','1:00'),
    (34,'Curl in piedi cavo basso con sbarra','3xmassime','1:10'),
    (34,'French press con manubri','3xmassime','1:30'),
    (34,'Squat goblet','3x8','1:10'),
    (34,'Bent-over rows','3x15','1:10'),
    (34,'Trazione inversa','3xmassime','1:20'),
    (34,'Plank','4x8','2:00'),
    (34,'Push up sulle ginocchia','4x10','2:00'),
    (34,'Pressa spalle','2x10','1:10'),
    (34,'Curl concentrato','3x15','2:00'),
    
    (35,'Curl in piedi cavo basso con sbarra','4x10','1:10'),
    (35,'French press bilanciere panca piana','4x8','1:20'),
    (35,'Alzate laterali','3xmassime','1:30'),
    (35,'Flessioni tricipiti','3x10','1:10'),
    (35,'Trazioni presa prona','2x10','1:00'),
    (35,'Bent-over rows','3x10','1:30'),
    (35,'Crunch inverso','4x8','1:30'),
    (35,'Leg curl seduto','2x10','1:00'),
    (35,'Curl in piedi bilanciere','3xmassime','1:30'),
    (35,'Good morning','4x10','2:00'),
    (35,'Stacchi rumeni su panca','3x10','1:30'),
    (35,'Tapis roulant','4x10','1:30'),
    (35,'Dip alle parallele','3x8','1:10'),
    (35,'Alzate gamba su fianco a terra','2x10','2:00'),
    (35,'Aperture peck back','3x8','1:30'),
    (35,'Reverse crunch','3x15','1:30'),
    (35,'Leg extension','3xmassime','1:10'),
    (35,'Affondi','2x15','1:30'),
    (35,'Leg press','2x15','1:20'),
    (35,'Push up','2x10','1:20'),
    
    (36,'Bent-over rows','3x10','1:10'),
    (36,'Estensioni per tricipiti','3x15','1:30'),
    (36,'Push up','3x10','1:10'),
    (36,'Curl concentrato','3x8','1:00'),
    (36,'Estensioni tricipiti al cavo','2x10','1:10'),
    (36,'French press bilanciere panca piana','2x15','2:00'),
    (36,'Military press','3x15','1:20'),
    (36,'Leg press','4x8','1:10'),
    (36,'Estensioni per tricipiti al cavo alto','3x8','2:00'),
    (36,'Dumbbell flyes','3xmassime','1:30'),
    (36,'Chiusure seduto adductor machine','5x5','2:00'),
    (36,'Alzate posteriori','2x15','1:30'),
    (36,'Squat hack','2x15','1:20'),
    (36,'Affondi','3x8','1:10'),
    (36,'Plank laterale','3x15','2:00'),
    (36,'Leg press orizzontale','3x15','1:00'),
    (36,'Curl femorali seduto','4x8','1:10'),
    (36,'Stacco rumeno','3x15','2:00'),
    (36,'Good morning','4x10','1:00'),
    (36,'Squat bulgaro','3x8','1:30'),
    
    (37,'Hammer curl','2x10','1:10'),
    (37,'Bent-over rows','3x10','1:30'),
    (37,'Calf in piedi su rialzo bilanciere','5x5','1:00'),
    (37,'Squat frontale','3xmassime','1:20'),
    (37,'Stacco rumeno','2x15','1:10'),
    (37,'Leg curl','4x10','1:30'),
    (37,'Plank laterale con sollevamento gamba','3xmassime','1:20'),
    (37,'Alzate laterali','5x5','1:20'),
    (37,'Rematore in piedi bilanciere','3x10','1:10'),
    (37,'Push up sulle ginocchia','4x10','1:00'),
    (37,'Rematore seduto al cavo basso','5x5','1:30'),
    (37,'Trazioni alla sbarra','3x8','1:00'),
    (37,'Alzate laterali singolo cavo in piedi','3x8','1:10'),
    (37,'Curl in piedi bilanciere','4x8','1:20'),
    (37,'Pulley basso triangolo','5x5','1:10'),
    (37,'Leg press orizzontale','3x15','1:30'),
    (37,'Military press','3x8','2:00'),
    (37,'French press bilanciere panca piana','5x5','1:00'),
    (37,'Squat sumo','2x10','1:20'),
    
    (38,'Plank','3x10','1:10'),
    (38,'Reverse hyperextension','3x8','1:20'),
    (38,'Squat goblet','3xmassime','1:20'),
    (38,'Alzate posteriori','5x5','2:00'),
    (38,'Reverse crunch','3x10','1:10'),
    (38,'Rematore seduto al cavo basso','3xmassime','1:20'),
    (38,'Push up','3x10','1:20'),
    (38,'Sollevamento laterale con manubri','4x10','2:00'),
    (38,'Alzate laterali singolo cavo in piedi','4x10','1:30'),
    (38,'Curl 2 manubri in piedi','4x8','1:10'),
    (38,'Addominali crunch su fitball','2x15','2:00'),
    (38,'Good morning','2x10','1:10'),
    
    (39,'Bent-over lateral raise','3xmassime','1:10'),
    (39,'Curl in piedi bilanciere','4x10','1:00'),
    (39,'Curl 2 manubri in piedi','2x15','2:00'),
    (39,'Flessioni tricipiti','2x10','1:10'),
    (39,'Leg press orizzontale','2x10','1:10'),
    (39,'Reverse crunch','5x5','1:00'),
    (39,'Curl femorali seduto','4x8','1:00'),
    (39,'Chiusure seduto adductor machine','3x10','1:20'),
    (39,'Calf raise','2x15','1:20'),
    (39,'Shoulder press','4x8','1:20'),
    (39,'Lunges','3x8','2:00'),
    (39,'Trazione inversa','4x8','1:20'),
    (39,'Chest press','3x10','1:30'),
    (39,'Rematore al cavo','2x15','1:00'),
    (39,'Extrarotazioni stile l in piedi elastico','3x8','1:10'),
    (39,'Dorsali pull over','3xmassime','1:20'),
    (39,'Affondi','5x5','1:20'),
    (39,'Curl martello','2x15','1:00'),
    (39,'Gatto','3x8','1:20'),
    
    (40,'Stacco rumeno','3x15','2:00'),
    (40,'Panca inclinata manubri','3xmassime','1:20'),
    (40,'Push up','4x10','1:20'),
    (40,'Hammer curl','3x10','1:20'),
    (40,'Alzate gamba su fianco a terra','4x10','1:10'),
    (40,'Gatto','3xmassime','2:00'),
    (40,'Russian twists','2x15','1:30'),
    (40,'Sollevamento laterale con manubri','4x8','1:20'),
    (40,'Trazioni alla sbarra','3x15','1:00'),
    (40,'Squat sumo','3x10','1:30'),
    (40,'Lat machine avanti','3x8','2:00'),
    (40,'Estensioni per tricipiti','5x5','1:20'),
    (40,'Tritonatori tricipiti','5x5','1:20'),
    (40,'Squat hack','3x8','1:20'),
    
    (41,'Reverse hyperextension','3x15','1:20'),
    (41,'Plank','3xmassime','2:00'),
    (41,'Alzate laterali singolo cavo in piedi','3x8','2:00'),
    (41,'Dumbbell pullover','2x15','1:10'),
    (41,'Military press','3x10','1:30'),
    (41,'French press con manubri','4x10','1:10'),
    (41,'Alzate posteriori','3x10','1:20'),
    (41,'Sollevamento laterale con manubri','3x10','1:10'),
    (41,'Squat bulgaro con manubri','2x15','1:30'),
    (41,'Gatto','4x8','1:00'),
    (41,'Dip alle parallele','4x8','2:00'),
    
    (42,'Trazioni alla sbarra','3x10','1:20'),
    (42,'Lat machine avanti','4x10','1:10'),
    (42,'Gatto','3x10','1:10'),
    (42,'Flessioni tricipiti','3x10','2:00'),
    (42,'Curl martello','3x15','1:20'),
    (42,'Curl femorali in piedi','3xmassime','1:20'),
    (42,'Rematore in piedi bilanciere','3x15','1:20'),
    (42,'Leg curl','2x15','1:10'),
    (42,'Pressa spalle','4x8','1:00'),
    (42,'Alzate posteriori','3x15','1:30'),
    (42,'Reverse hyperextension','4x10','1:30'),
    (42,'Aperture peck back','5x5','1:20'),
    (42,'Sollevamento laterale con manubri','2x10','2:00'),
    (42,'Alzate gamba su fianco a terra','3x8','1:20'),
    (42,'Leg curl a 45 gradi','3xmassime','1:30'),
    (42,'Dip alle parallele','2x10','2:00'),
    (42,'Chiusure seduto adductor machine','2x10','1:30'),
    
    (43,'Estensioni per tricipiti','4x8','1:20'),
    (43,'Lat pulldown','4x10','1:30'),
    (43,'Gatto','2x15','1:00'),
    (43,'Rematore seduto al cavo basso','5x5','2:00'),
    (43,'Tritonatori tricipiti','3xmassime','1:30'),
    (43,'Lunges','4x8','1:10'),
    (43,'Panca piana bilanciere','3x15','1:30'),
    (43,'Curl concentrato','4x10','1:10'),
    (43,'Pulley basso triangolo','5x5','1:20'),
    (43,'Lat machine avanti','3x15','2:00'),
    (43,'Flessioni tricipiti','4x10','1:00'),
    (43,'Reverse crunch','2x10','1:30'),
    
    (44,'Stacco rumeno','5x5','2:00'),
    (44,'Plank laterale con sollevamento gamba','3x15','1:10'),
    (44,'Curl concentrato','3x8','1:10'),
    (44,'Push up sulle ginocchia','3x10','1:10'),
    (44,'Squat bilanciere','3x10','1:00'),
    (44,'Plank','2x10','1:30'),
    (44,'Dumbbell flyes','3x15','1:30'),
    (44,'Curl in piedi cavo basso con sbarra','3x8','1:30'),
    (44,'Calf in piedi su rialzo bilanciere','5x5','1:10'),
    (44,'Leg press','3xmassime','2:00'),
    (44,'Alzate gamba su fianco a terra','5x5','2:00'),
    (44,'Leg curl','3x8','1:20'),
    (44,'Squat frontale','2x10','1:00'),
    (44,'Gatto','4x8','2:00'),
    (44,'Affondi','3x15','1:00'),
    (44,'Pulley alto','4x10','1:00'),
    (44,'Squat sumo','2x15','1:10'),
    (44,'Trazione inversa','4x10','1:30'),
    (44,'Curl con manubri in supinazione','4x10','2:00'),
    (44,'Leg curl a 45 gradi','4x10','1:20'),
    
    (45,'Extrarotazioni stile l in piedi elastico','2x10','1:30'),
    (45,'Dorsali pull over','2x10','2:00'),
    (45,'Dip alle parallele','4x10','1:00'),
    (45,'Leg curl seduto','4x8','1:20'),
    (45,'Rematore seduto al cavo basso','3x10','2:00'),
    (45,'Calf in piedi su rialzo bilanciere','2x10','1:20'),
    (45,'Clean and press','5x5','1:00'),
    (45,'Panca inclinata manubri','3x8','1:00'),
    (45,'Pressa Arnold','5x5','1:10'),
    (45,'Leg press','3x15','1:20'),
    (45,'Push up','2x10','1:30'),
    (45,'Estensioni per tricipiti al cavo alto','2x10','1:30'),
    (45,'Hammer curl','5x5','1:10'),
    (45,'Calf raise','4x10','1:20'),
    
    (46,'Tritonatori tricipiti','2x10','1:10'),
    (46,'Deadlift','4x10','1:20'),
    (46,'Squat bulgaro con manubri','4x10','1:20'),
    (46,'Bent-over lateral raise','2x10','1:00'),
    (46,'Push up','5x5','1:00'),
    (46,'Calf in piedi su rialzo bilanciere','5x5','1:30'),
    (46,'Plank','3xmassime','1:30'),
    (46,'Squat bilanciere','3x15','1:20'),
    (46,'Rematore seduto al cavo basso','5x5','1:10'),
    (46,'Crunch','3x15','1:20'),
    (46,'Curl concentrato','3x10','1:30'),
    
    (47,'Rematore al cavo','4x8','1:00'),
    (47,'Clean and press','3x8','1:20'),
    (47,'Crunch inverso','4x8','1:00'),
    (47,'Curl femorali seduto','2x10','1:00'),
    (47,'Estensioni tricipiti al cavo','3x10','2:00'),
    (47,'Extrarotazioni stile l in piedi elastico','3x10','1:30'),
    (47,'Chest press','2x10','1:00'),
    (47,'Lunges','5x5','2:00'),
    (47,'Plank','3x10','1:20'),
    (47,'Gatto','3x10','1:30'),
    
    (48,'French press bilanciere panca piana','4x8','1:00'),
    (48,'Reverse crunch','3xmassime','1:20'),
    (48,'Push up sulle ginocchia','3x10','1:20'),
    (48,'Curl 2 manubri in piedi','5x5','1:20'),
    (48,'Shoulder press con manubri','3x8','1:00'),
    (48,'Trazione inversa','2x15','1:30'),
    (48,'Curl martello','4x8','1:30'),
    (48,'Calf in piedi su rialzo bilanciere','3x10','2:00'),
    (48,'Squat bilanciere','4x10','1:00'),
    (48,'Flessioni tricipiti','3x15','1:00'),
    (48,'Curl femorali in piedi','3x15','2:00'),
    (48,'Alzate gamba su fianco a terra','3xmassime','1:20'),
    (48,'Plank laterale','2x10','1:10'),
    
    (49,'Crunch','4x8','1:20'),
    (49,'Bench press','2x15','1:20'),
    (49,'Addominali crunch su fitball','5x5','1:30'),
    (49,'Stacco rumeno','4x10','1:30'),
    (49,'Leg extension','4x8','1:30'),
    (49,'Chiusure seduto adductor machine','2x10','1:00'),
    (49,'Calf raise','2x15','1:00'),
    (49,'Plank laterale','3x10','1:20'),
    (49,'Alzate laterali','2x15','1:30'),
    (49,'Bent-over lateral raise','5x5','1:20'),
    (49,'Squat sumo','3xmassime','1:10'),
    (49,'Calf in piedi su rialzo bilanciere','3x10','1:30'),
    (49,'Curl femorali seduto','2x10','1:30'),
    (49,'Alzate laterali singolo cavo in piedi','5x5','1:10'),
    (49,'Squat frontale','3xmassime','1:10'),
    (49,'Alzate posteriori','3xmassime','1:10'),

    (50,'Push up','5x5','1:30'),
    (50,'Stacchi rumeni su panca','3x15','1:10'),
    (50,'Alzate laterali singolo cavo in piedi','2x15','1:10'),
    (50,'Dip alle parallele','3x15','1:20'),
    (50,'Bent-over rows','4x10','1:20'),
    (50,'Sollevamento laterale con manubri','3xmassime','1:30'),
    (50,'Shoulder press','4x10','1:10'),
    (50,'Squat goblet','3x8','2:00'),
    (50,'Leg extension','3x10','1:10'),
    (50,'Aperture peck back','2x10','1:30');
--FINE INSERT-------------------------------------------------------------------

--INIZIO QUERY------------------------------------------------------------------

--Trova tutti i nomi degli esercizi che allenano un categoria di muscoli a scelta

SELECT es.nome
FROM esercizio es 
    JOIN esercizio_gruppomuscolare eg   ON es.nome = eg.esercizio 
    JOIN gruppomuscolare gm             ON gm.nome = eg.gruppomuscolare 
WHERE categoria = 'Braccia';


--Ordina i corsi che hanno avuto maggiori frequentazioni tra tutte le edizioni segnalando il numero di partecipanti, distinguendo per palestra e riportando il guadagno ricavato

SELECT c.nome, c.cittapalestra, c.indirizzopalestra, count(cc.cliente) AS tot_partecipanti, sum(c.prezzo) AS ricavi_corso
FROM corso AS c 
    JOIN cliente_corso AS cc 
    ON c.nome = cc.nomecorso 
        AND c.edizione = cc.edizionecorso 
        AND cc.cittapalestracorso = c.cittapalestra 
        AND cc.indirizzopalestracorso = c.indirizzopalestra
GROUP BY c.nome, c.cittapalestra, c.indirizzopalestra 
ORDER BY tot_partecipanti DESC;


--Trova e ordina per tempo di iscrizione all'area fitness i clienti riportando il tempo di iscrizione e soldi spesi nell'area fitness

SELECT c.nome, c.cognome, SUM(AGE(DataFine,DataInizio)) AS tempo_iscrizione, SUM(af.prezzo) AS tot_ricavi 
FROM cliente AS c 
    JOIN areafitness AS af ON af.cliente = c.cf 
GROUP BY c.nome, c.cognome
ORDER BY tempo_iscrizione DESC;


--Mostra in ordine i clienti che attualmente allenano piu' volte una categoria di muscoli a scelta

SELECT c.nome, c.cognome, COUNT(c.cf) AS num_volte
FROM cliente AS c
    JOIN areafitness AS af ON af.cliente = c.cf 
    JOIN scheda AS s ON s.areafitness = af.id
    JOIN esercizio_scheda AS es             ON es.scheda = s.id JOIN esercizio AS e ON e.nome = es.esercizio
    JOIN esercizio_gruppomuscolare AS eg    ON eg.esercizio = e.nome
    JOIN gruppomuscolare AS gm              ON gm.nome = eg.gruppomuscolare
    JOIN (SELECT c.cf AS cliente_last_scheda, MAX(s.DataFine) AS data_last_scheda
            FROM cliente AS c JOIN areafitness AS af ON af.cliente = c.cf 
                JOIN scheda AS s ON s.areafitness = af.id
            GROUP BY c.cf) AS last_scheda
    ON c.cf = last_scheda.cliente_last_scheda AND s.DataFine = last_scheda.data_last_scheda 
WHERE gm.categoria = 'Spalle' 
GROUP BY c.cf ORDER BY num_volte DESC;


--Mostra in ordine le palestre che guadagnano di piu' dai corsi in un anno a scelta

SELECT guadagno_corsi.cittapalestra, guadagno_corsi.indirizzopalestra, sum(guadagno_corso) AS guadagno_tot 
FROM (SELECT c.nome,c.edizione,c.cittapalestra, c.indirizzopalestra,c.datainizio,count(cc.cliente)*c.prezzo AS guadagno_corso
        FROM corso c
            JOIN cliente_corso cc ON cc.cittapalestracorso = c.cittapalestra 
                                    AND cc.edizionecorso = c.edizione 
                                    AND cc.indirizzopalestracorso = c.indirizzopalestra 
                                    AND cc.nomecorso = c.nome
        GROUP BY c.nome,c.edizione,c.cittapalestra, c.indirizzopalestra) AS guadagno_corsi
GROUP BY guadagno_corsi.cittapalestra, guadagno_corsi.indirizzopalestra, EXTRACT(YEAR FROM guadagno_corsi.datainizio)
HAVING EXTRACT(YEAR FROM guadagno_corsi.datainizio)=2022
ORDER BY guadagno_tot DESC;


--Mostra in ordine i clienti che hanno speso di piu' in totale riportando l'importo

SELECT c.nome, c.cognome, iscrizione_tot + COALESCE(areafitness_tot, 0) + COALESCE(corso_tot, 0) AS pagamento_tot
FROM cliente c
    JOIN (SELECT c.cf, c.nome, c.cognome, SUM(lp.prezzoiscrizione) AS iscrizione_tot
            FROM cliente c
                JOIN iscrizione i       ON i.cliente = c.cf
                JOIN listinoprezzi lp 	ON lp.id = i.listino
            GROUP BY c.cf) AS iscr
    ON c.cf=iscr.cf
    LEFT JOIN (SELECT c.cf, c.nome, c.cognome, SUM(a.prezzo) AS areafitness_tot
                FROM cliente c
                    JOIN areafitness a ON a.cliente = c.cf
                GROUP BY c.cf) AS ar
    ON iscr.cf=ar.cf
    LEFT JOIN (SELECT cl.cf, cl.nome, cl.cognome, sum(c.prezzo) AS corso_tot
        FROM cliente cl
            JOIN cliente_corso cc 	ON cc.cliente = cl.cf
            JOIN corso c 			ON c.indirizzopalestra = cc.indirizzopalestracorso 
	                                    AND c.cittapalestra = cc.cittapalestracorso 
	                                    AND c.nome = cc.nomecorso 
	                                    AND c.edizione = cc.edizionecorso
        GROUP BY cl.cf) AS co
    ON iscr.cf=co.cf
ORDER BY pagamento_tot DESC;


--Mostra in ordine gli istruttori che si occupano attualmente di piu' clienti nell'area fitness con relativo numero di clienti

SELECT i.nome,i.cognome,count(af.cliente) AS clienti
FROM istruttore i
    JOIN scheda s ON s.istruttore = i.cf
    JOIN areafitness af ON af.id = s.areafitness
    JOIN (SELECT c.cf AS cliente_last_scheda, MAX(s.DataFine) AS data_last_scheda
            FROM cliente AS c 
                JOIN areafitness    AS af  ON af.cliente = c.cf 
                JOIN scheda         AS s   ON s.areafitness = af.id
            GROUP BY  c.cf) AS last_scheda 
    ON af.cliente = last_scheda.cliente_last_scheda AND s.DataFine = last_scheda.data_last_scheda
WHERE s.DataFine>CURRENT_DATE
GROUP BY i.cf
ORDER BY clienti DESC;

---FINE QUERY-----------------------------------------------------------------------------

create index indice_iscrizione on Iscrizione(Cliente,Scadenza);