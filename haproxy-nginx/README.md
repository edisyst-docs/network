# HAProxy - Esempio con NGINX come Bilanciatore Primario
NGINX è un popolare server web che può anche funzionare come bilanciatore di carico. 
Configureremo NGINX come bilanciatore di carico primario in cascata con HAProxy.
NGINX: Facile da configurare e ampiamente utilizzato
```bash
Client ----> Bilanciatore Primario ----> HAProxy ----> Server Applicativi
              (es. NGINX)           (Nodi Multipli)
```
              
- `Rete Docker`: Una rete Docker chiamata `my_network` permette ai container di comunicare tra loro.  
- `Backend Web Containers`: Tre container Nginx (`web1, web2, web3`) simuleranno i server web.   
- `HAProxy Secondario`: Un container HAProxy distribuisce il traffico tra i container web.   
- `Bilanciatore di Carico Primario`: Un container NGINX che distribuisce il traffico tra le istanze di HAProxy secondarie.   



## 1. Creare una rete Docker con 3 Container Web Backend
Creo sempre 3 container Nginx `web1, web2, web3` 
```bash
docker network create my_network
docker run -d --name web1 --network my_network -p 8081:80 nginx
docker run -d --name web2 --network my_network -p 8082:80 nginx
docker run -d --name web3 --network my_network -p 8083:80 nginx
```


## 2. Configurare e Avviare HAProxy
Creo sempre il file di config per HAProxy `haproxy.cfg`: definisce come HAProxy bilancia il carico tra `web1, web2, web3`
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
Creo il container HAProxy con `haproxy.cfg` come config (questa scrittura funge da Windows):
```bash
docker run -d --name haproxy --network my_network -p 8080:80 -p 8404:8404 -v .\haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro haproxy:latest
```


## 3. Configurare e Avviare NGINX come Bilanciatore di Carico Primario
Crea il file di config per NGINX `nginx.conf`:
```bash
events {}

http {
    upstream haproxy_backends {
        server haproxy:80;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://haproxy_backends;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

Avvio il container NGINX con `nginx.conf` come config (questa scrittura funge da Windows):
```bash
docker run -d --name nginx --network my_network -p 80:80 -v .\Caddyfile:/etc/nginx/Caddyfile:ro nginx:latest
```


## 4. Verifica dell'Infrastruttura
Apro il browser all'indirizzo http://localhost:80. Si vede la home di Nginx.  
Ogni volta che ricarico la pagina, HAProxy bilancia il carico tra i diversi server `web1, web2, web3`

