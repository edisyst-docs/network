# HAProxy - Esempio con un bilanciatore di carico
L'idea è creare un bilanciatore di carico primario (che sarà un servizio Docker simile a HAProxy) e diverse  
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
Creo 3 container Nginx `web1, web2, web3` che rispondano con un semplice messaggio
```bash
docker network create my_network
docker run -d --name web1 --network my_network -p 8081:80 nginx
docker run -d --name web2 --network my_network -p 8082:80 nginx
docker run -d --name web3 --network my_network -p 8083:80 nginx
```


## 2. Configurare e Avviare HAProxy
Creo il file di config per HAProxy `haproxy.cfg`: definisce come HAProxy bilancia il carico tra i container web1,2,3
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
```
Creo il container HAProxy con `haproxy.cfg` come config (questa scrittura funge da Windows):
```bash
docker run -d --name haproxy --network my_network -p 8080:80 -v .\haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro haproxy:latest
```


## 3. Configurare e Avviare il Bilanciatore di Carico Primario
Uso un altro HAProxy come bilanciatore di carico primario per distribuire il traffico tra le istanze di HAProxy secondarie.  
Creo un altro `haproxy_primary.cfg` di config (molto simile al precedente) per il bilanciatore HAProxy primario
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
Avvio il container HAProxy_primario con `haproxy_primary.cfg` come config:
```bash
docker run -d --name haproxy_primary --network my_network -p 80:80 -v .\haproxy_primary.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro haproxy:latest
```


## 4. Verifica dell'Infrastruttura
Apro il browser all'indirizzo http://localhost:80. Si vede la home di Nginx.  
Ogni volta che ricarico la pagina, HAProxy bilancia il carico tra i diversi server `web1, web2, web3`

