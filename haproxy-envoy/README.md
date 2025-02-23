# HAProxy - Esempio con Envoy come Bilanciatore Primario
Envoy: Proxy potente e flessibile con capacità avanzate di bilanciamento del carico.
```bash
Client ----> Bilanciatore Primario ----> HAProxy ----> Server Applicativi
              (es. Envoy)           (Nodi Multipli)
```
              
- `Rete Docker`: Una rete Docker chiamata `my_network` permette ai container di comunicare tra loro.  
- `Backend Web Containers`: Tre container Nginx (`web1, web2, web3`) simuleranno i server web.   
- `HAProxy Secondario`: Un container HAProxy distribuisce il traffico tra i container web.   
- `Bilanciatore di Carico Primario`: Un container Envoy che distribuisce il traffico tra le istanze di HAProxy secondarie.   



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


## 3. Configurare e Avviare Envoy come Bilanciatore di Carico Primario
Crea il `envoy.yml` per avviare Envoy:
```yaml
static_resources:
  listeners:
    - name: listener_0
      address:
        socket_address: { address: 0.0.0.0, port_value: 80 }
      filter_chains:
        - filters:
            - name: envoy.http_connection_manager
              config:
                stat_prefix: ingress_http
                route_config:
                  name: local_route
                  virtual_hosts:
                    - name: local_service
                      domains: ["*"]
                      routes:
                        - match: { prefix: "/" }
                          route: { cluster: service_haproxy }
                http_filters:
                  - name: envoy.router
  clusters:
    - name: service_haproxy
      connect_timeout: 0.25s
      type: LOGICAL_DNS
      lb_policy: ROUND_ROBIN
      hosts:
        - socket_address: { address: haproxy, port_value: 80 }
```

# RIFARE
Avvio il container Envoy con `envoy.yaml` come config (questa scrittura funge da Windows):
```bash
docker run -d --name envoy --network my_network -p 80:80 -v .\envoy.yaml:/etc/envoy/envoy.yaml:ro envoyproxy/envoy:v1.16.0
```


# RIFARE
## 4. Verifica dell'Infrastruttura
Apro il browser all'indirizzo http://localhost:80. Si vede la home di Nginx.  
Ogni volta che ricarico la pagina, HAProxy bilancia il carico tra i diversi server `web1, web2, web3`

