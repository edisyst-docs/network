# HAProxy - Esempio con bilanciatore di carico e monitoring del server web in real time
L'idea è di creare un bilanciatore di carico primario (che sarà un servizio Docker simile a HAProxy) e diverse  
istanze di HAProxy che distribuiranno il traffico a container web backend.
```bash
Client ----> Bilanciatore Primario ----> HAProxy ----> Server Applicativi
              (es. AWS ELB)           (Nodi Multipli)
```
              
- `Rete Docker`: Una rete Docker chiamata `my_network` permette ai container di comunicare tra loro.  
- `Backend Web Containers`: Tre container Nginx (`web1, web2, web3`) simuleranno i server web.   
- `HAProxy Secondario`: Un container HAProxy distribuisce il traffico tra i container web.   
- `Bilanciatore di Carico Primario`: Un altro container HAProxy che distribuisce il traffico tra le istanze di HAProxy secondarie.   

Questa config fornisce un esempio pratico di come i bilanciatori di carico possono essere configurati in cascata   


## 1. Creare una rete Docker con 3 Container Web Backend
Creo 3 container Nginx web1,2,3 che rispondano con un semplice messaggio.
```bash
docker network create my_network
docker run -d --name web1 --network my_network -p 8081:80 nginx
docker run -d --name web2 --network my_network -p 8082:80 nginx
docker run -d --name web3 --network my_network -p 8083:80 nginx
```


## 2. Configurare e Avviare HAProxy
Dobbiamo modificare il file di configurazione di HAProxy `haproxy.cfg` per abilitare l'interfaccia di stato
```bash
global
    log stdout format raw local0

defaults
    log global
    mode http
    option httplog
    timeout connect 5000ms
    timeout client  50000ms
    timeout server  50000ms

frontend http_front
    bind *:80
    default_backend http_back

backend http_back
    balance roundrobin
    server web1 web1:80 check
    server web2 web2:80 check
    server web3 web3:80 check

listen stats
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 10s
```
Questa config aggiunge la sezione `listen stats` che abilita l'interfaccia di stato su `http://<haproxy-ip>:8404/stats`

Avvio il container HAProxy con questa nuova config:
```bash
docker run -d --name haproxy --network my_network -p 8080:80 -p 8404:8404 -v .\haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro haproxy:latest
```

### 2.1 Accedere all'Interfaccia di Stato
Apri un browser e vai all'indirizzo http://localhost:8404/stats

Vedrai una pagina web con informazioni sui server web che HAProxy sta utilizzando in tempo reale

### 2.2 Monitorare da Console
Puoi anche accedere alle informazioni di stato da dentro il container HAProxy col comando `curl`:
```bash
docker exec -it haproxy /bin/sh
curl http://localhost:8404/stats
```
Questo comando restituirà l'output HTML che puoi leggere per vedere quale server web è attualmente in uso.

Questa configurazione ti permette di monitorare in tempo reale quale dei server web (web1, web2, web3) viene utilizzato da HAProxy.  
L'interfaccia di stato fornisce una visualizzazione web dettagliata e aggiornata periodicamente delle prestazioni e  
dello stato dei server back-end, utile per scopi didattici e di debug.


## 3. Configurare il Bilanciatore di Carico Primario
Uso un altro HAProxy come bilanciatore di carico primario che distribuisce il traffico tra le istanze di HAProxy secondarie. 
Creo un altro file di config per il bilanciatore primario: `haproxy_primary.cfg`
```bash
global
    log stdout format raw local0

defaults
    log global
    mode http
    option httplog
    timeout connect 5000ms
    timeout client  50000ms
    timeout server  50000ms

frontend http_front
    bind *:80
    default_backend http_back

backend http_back
    balance roundrobin
    server haproxy1 haproxy:80 check
```
Avvio il container HAProxy_primario con questa config:
```bash
docker run -d --name haproxy_primary --network my_network -p 80:80 -v .\haproxy_primary.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro haproxy:latest
```


## 4. Verifica dell'Infrastruttura
Apro il browser all'indirizzo http://localhost:80. Si vede la home di Nginx. 
Ogni volta che ricarico la pagina, HAProxy bilancia il carico tra i diversi server web1,2,3


