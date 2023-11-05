#include <cstdio>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <vector>
#include <string>
#include <cstring>
#include "dependencies/include/libpq-fe.h"

#define PG_HOST "127.0.0.1"  // oppure " localhost " o " postgresql "
#define PG_USER "postgres"   // il vostro nome utente
#define PG_PORT "5432"

using namespace std;

PGconn *connect(const char *host, const char *user, const char *db, const char *pass, const char *port);
PGresult *executePQ(PGconn *conn, const char *query);

void checkConnection(PGconn *conn);
void checkResults(PGresult *res, const PGconn *conn);
void printResults(PGconn *conn, PGresult *res);
void printLine(const vector<int> &maxChar);


int main(int argc, char **argv) {
    cout << "Nome Database: ";
    char db[50];
    cin >> db;
    cout << "Password: ";
    char password[50];
    cin >> password;
    PGconn *conn = connect(PG_HOST, PG_USER, db, password, PG_PORT);

    const int numQuery = 7;
    const char *query[numQuery] = {"SELECT es.nome \
                                    FROM esercizio es \
                                    JOIN esercizio_gruppomuscolare eg ON es.nome = eg.esercizio \
                                    JOIN gruppomuscolare gm on gm.nome = eg.gruppomuscolare \
                                    where categoria = '%s'",
                                   "select c.nome, c.cittapalestra, c.indirizzopalestra, count(cc.cliente) as tot_partecipanti, sum(c.prezzo) as ricavi_corso\
                                    from corso as c \
                                    join cliente_corso as cc on c.nome = cc.nomecorso and c.edizione = cc.edizionecorso and cc.cittapalestracorso = c.cittapalestra and cc.indirizzopalestracorso = c.indirizzopalestra\
                                    group by c.nome, c.cittapalestra, c.indirizzopalestra \
                                    order by tot_partecipanti desc",
                                   "SELECT c.nome, c.cognome, SUM(AGE(DataFine,DataInizio)) AS tempo_iscrizione, SUM(af.prezzo) AS tot_ricavi \
                                    FROM cliente AS c \
                                    JOIN areafitness AS af ON af.cliente = c.cf \
                                    GROUP BY c.nome, c.cognome\
                                    ORDER BY tempo_iscrizione DESC;",
                                   "SELECT c.nome, c.cognome, COUNT(c.cf) AS num_volte\
                                    FROM cliente AS c\
                                    JOIN areafitness AS af ON af.cliente = c.cf \
                                    JOIN scheda AS s ON s.areafitness = af.id\
                                    JOIN esercizio_scheda AS es ON es.scheda = s.id JOIN esercizio AS e ON e.nome = es.esercizio\
                                    JOIN esercizio_gruppomuscolare AS eg ON eg.esercizio = e.nome\
                                    JOIN gruppomuscolare AS gm ON gm.nome = eg.gruppomuscolare\
                                    JOIN(\
                                    SELECT c.cf AS cliente_last_scheda, MAX(s.DataFine) AS data_last_scheda\
                                    FROM cliente AS c JOIN areafitness AS af ON af.cliente = c.cf \
                                    JOIN scheda as s ON s.areafitness = af.id\
                                    GROUP BY c.cf) AS last_scheda\
                                    ON c.cf = last_scheda.cliente_last_scheda AND s.DataFine = last_scheda.data_last_scheda \
                                    WHERE gm.categoria = '%s' \
                                    GROUP BY c.cf ORDER BY num_volte DESC;",
                                   "SELECT guadagno_corsi.cittapalestra, guadagno_corsi.indirizzopalestra,sum(guadagno_corso) AS guadagno_tot \
                                    FROM(\
                                    SELECT c.nome,c.edizione,c.cittapalestra, c.indirizzopalestra,c.datainizio,count(cc.cliente)*c.prezzo AS guadagno_corso\
                                    FROM corso c\
                                    JOIN cliente_corso cc ON cc.cittapalestracorso = c.cittapalestra AND cc.edizionecorso = c.edizione AND cc.indirizzopalestracorso = c.indirizzopalestra AND cc.nomecorso = c.nome\
                                    GROUP BY c.nome,c.edizione,c.cittapalestra, c.indirizzopalestra\
                                    ) AS guadagno_corsi\
                                    GROUP BY guadagno_corsi.cittapalestra, guadagno_corsi.indirizzopalestra,EXTRACT(YEAR FROM guadagno_corsi.datainizio)\
                                    HAVING EXTRACT(YEAR FROM guadagno_corsi.datainizio)=%d\
                                    ORDER BY guadagno_tot desc",
                                   "SELECT c.nome, c.cognome, iscrizione_tot + COALESCE(areafitness_tot, 0) + COALESCE(corso_tot, 0) AS pagamento_tot\
                                    FROM cliente c\
	                                JOIN (SELECT c.cf, c.nome, c.cognome, SUM(lp.prezzoiscrizione) AS iscrizione_tot\
		                            FROM cliente c\
			                        JOIN iscrizione i ON i.cliente = c.cf\
			                        JOIN listinoprezzi lp 	ON lp.id = i.listino\
		                            GROUP BY c.cf) as iscr\
	                                ON c.cf=iscr.cf\
	                                LEFT JOIN (SELECT c.cf, c.nome, c.cognome, SUM(a.prezzo) AS areafitness_tot\
		                            from cliente c\
			                        JOIN areafitness a 		ON a.cliente = c.cf\
		                            GROUP BY c.cf) AS ar\
                                	ON iscr.cf=ar.cf\
                                	LEFT JOIN (SELECT cl.cf, cl.nome, cl.cognome, sum(c.prezzo) AS corso_tot\
		                                from cliente cl\
			                                JOIN cliente_corso cc 	ON cc.cliente = cl.cf\
			                                JOIN corso c 			ON c.indirizzopalestra = cc.indirizzopalestracorso \
			   							                                AND c.cittapalestra = cc.cittapalestracorso \
			   							                                AND c.nome = cc.nomecorso \
			   							                                AND c.edizione = cc.edizionecorso\
		                                GROUP BY cl.cf) AS co\
                                	ON iscr.cf=co.cf\
                                    ORDER BY pagamento_tot desc",
                                   "select i.nome,i.cognome,count(af.cliente) as clienti\
                                    from istruttore i\
                                    join scheda s on s.istruttore = i.cf\
                                    join areafitness af on af.id = s.areafitness\
                                    join\
                                    (SELECT c.cf AS cliente_last_scheda, MAX(s.DataFine) AS data_last_scheda\
                                    FROM cliente AS c \
                                    JOIN areafitness AS af ON af.cliente = c.cf \
                                    JOIN scheda as s ON s.areafitness = af.id\
                                    GROUP BY  c.cf) AS last_scheda \
                                    ON af.cliente = last_scheda.cliente_last_scheda AND s.DataFine = last_scheda.data_last_scheda\
                                    where s.DataFine>CURRENT_DATE\
                                    group by i.cf\
                                    order by clienti desc"};
    int q;
    do {
        cout << endl;
        cout << "1> Trova tutti i nomi degli esercizi che allenano un categoria di muscoli a scelta\n";
        cout << "2> Ordina i corsi che hanno avuto maggiori frequentazioni tra tutte le edizioni segnalando il numero di partecipanti, distinguendo per palestra e riportando il guadagno ricavato\n";
        cout << "3> Trova e ordina per tempo di iscrizione all'area fitness i clienti riportando il tempo di iscrizione e soldi spesi nell'area fitness\n";
        cout << "4> Mostra in ordine i clienti che attualmente allenano piu' volte una categoria di muscoli a scelta\n";
        cout << "5> Mostra in ordine le palestre che guadagnano di piu' dai corsi in un anno a scelta\n";
        cout << "6> Mostra in ordine i clienti che hanno speso di piu' in totale riportando l'importo\n";
        cout << "7> Mostra in ordine gli istruttori che si occupano attualmente di piu' clienti nell'area fitness con relativo numero di clienti \n";
        cout << "Query da eseguire (0 per uscire): ";
        
        cin >> q;

        while (q < 0 || q > numQuery) {
            cout << "Fuori dal range\n";
            cout << "Query da eseguire (0 per uscire): ";
            cin >> q;
        }

        char queryTemp[2000];
        switch (q) {
        case 1:
        case 4:
        {
            string categorie[] = {"Gambe", "Busto", "Braccia", "Resistenza", "Schiena", "Spalle"};
            
            char categoria[20];
            cout << "\nScegli tra:\n";

            for (int i = 0; i < sizeof(categorie)/sizeof(string); i++) {
                cout << (i + 1) << "> " << categorie[i] << endl;
            }

            cout << "Inserisci la categoria da cercare: ";
            cin >> categoria;
            sprintf(queryTemp, query[q - 1], categoria);
            printResults(conn, executePQ(conn, queryTemp));
            break;
        }
        case 5:
        {
            int anno;
            cout << "Scegli tra: \n-2021\n-2022\n-2023\n";
            cout << "Inserisci l'anno: ";
            cin >> anno;
            sprintf(queryTemp, query[4], anno);
            printResults(conn, executePQ(conn, queryTemp));
            break;
        }
        case 0:
            cout << "\n\tFine programma\n\n";
            break;
        default:
            printResults(conn, executePQ(conn, query[q - 1]));
            break;
        }

    } while (q != 0);
    
    PQfinish(conn);
    return 0;
}

PGconn *connect(const char *host, const char *user, const char *db, const char *pass, const char *port) {
    char conninfo[256];
    sprintf(conninfo, "user=%s password=%s dbname=\'%s\' hostaddr=%s port=%s",
            user, pass, db, host, port);
    PGconn *conn = PQconnectdb(conninfo);
    checkConnection(conn);
    return conn;
}

void checkConnection(PGconn *conn) {
    if (PQstatus(conn) != CONNECTION_OK) {
        cout << "Errore di connessione" << PQerrorMessage(conn) << endl;
        PQfinish(conn);
        exit(1);
    }
    cout << "Connessione avvenuta correttamente" << endl;
}

PGresult *executePQ(PGconn *conn, const char *query) {
    PGresult *res = PQexec(conn, query);
    checkResults(res, conn);
    return res;
}

void checkResults(PGresult *res, const PGconn *conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << " Risultati inconsistenti ! " << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }
}

void printResults(PGconn *conn, PGresult *res) {
    cout<<"\n\n";
    checkResults(res, conn);
    const int rows = PQntuples(res);
    const int cols = PQnfields(res);

    vector<vector<string>> data(rows + 1, vector<string>(cols));
    vector<int> maxChar(cols);

    for (int col = 0; col < cols; ++col) {
        data[0][col] = PQfname(res, col);
        maxChar[col] = data[0][col].size();
    }

    for (int row = 0; row < rows; ++row) {
        for (int col = 0; col < cols; ++col) {
            string value = PQgetvalue(res, row, col);
            if (value == "t" || value == "f") {
                value = (value == "t") ? "si" : "no";
            }
            data[row + 1][col] = value;
            maxChar[col] = max(maxChar[col], static_cast<int>(value.size()));
        }
    }

    printLine(maxChar);

    for (int row = 0; row < rows + 1; ++row) {
        cout << "| ";
        for (int col = 0; col < cols; ++col) {
            cout << data[row][col];
            cout << string(maxChar[col] - data[row][col].size(), ' ') << " | ";
        }
        cout << endl;

        if (row == 0) {
            printLine(maxChar);
        }
    }
    printLine(maxChar);
}

void printLine(const vector<int> &maxChar) {
    for (int length : maxChar) {
        cout << "+" << string(length + 2, '-');
    }
    cout << "+" << endl;
}
