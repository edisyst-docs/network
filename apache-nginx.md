# APACHE2
### Comandi
1. [x] `start, stop, restart, reload`  => controllare il servizio Apache
2. [x] `a2ensite, a2dissite`           => abilitare e disabilitare siti
3. [x] `a2enmod , a2dismod`            => abilitare e disabilitare moduli
```bash
systemctl reload     apache2  # Ricarica la config di apache2
systemctl disable    apache2  # Disabilita apache2 all'avvio 
systemctl is-enabled apache2  # Verifica se apache2 è abilitato
```

### Config
I principali file e directory di config si trovano in `/etc/apache2` su sistemi `Debian/Ubuntu`
* `/etc/apache2/apache2.conf`     =>  File di config principale
  * `/etc/apache2/ports.conf`     =>  Configura le porte su cui Apache ascolta
* `/etc/apache2/sites-available/` =>  Config dei siti disponibili
* `/etc/apache2/sites-enabled/`   =>  Collegamenti simbolici ai siti attualmente abilitati

###  Abilitare e disabilitare siti e moduli
```bash
a2ensite   mio_sito.conf   # Abilita un sito
apache2ctl configtest      # controlla il file di configurazione per errori
systemctl  reload apache2

a2dissite mio_sito.conf    # Disabilita un sito

a2enmod   rewrite          # Abilita il modulo mod_rewrite
a2dismod  nome_modulo      # Disabilita un modulo
systemctl restart apache2
```



# NGINX
```bash
nginx -c /path/nginx.conf  # usa un file di config alternativo

nginx -s reload       # Ricarica la config di Nginx 
nginx -s stop         # Stoppa Nginx
nginx -s reopen       # Riapre i file di log

nginx -t     # controlla il file di configurazione per errori
nginx -V     # info sui moduli compilati e le opzioni
```

### Comandi (gli stessi di apache2)
1. [x] `start, stop, restart, reload`  => controllare il servizio Apache
2. [x] `link simbolici`                => abilitare e disabilitare siti
3. [x] `link simbolici`                => abilitare e disabilitare moduli
```bash
systemctl stop       nginx    # Stoppa nginx
systemctl reload     nginx    # Avvia la config di nginx
systemctl disable    nginx    # Disabilita nginx all'avvio 
systemctl is-enabled nginx    # Verifica se nginx è abilitato
```

### Config
I principali file e directory di config si trovano in `/etc/apache2` su sistemi `Debian/Ubuntu`
* `/etc/nginx/nginx.conf`       =>  File di config principale
* `/etc/nginx/sites-available/` =>  Config dei siti disponibili
* `/etc/nginx/sites-enabled/`   =>  Collegamenti simbolici ai siti attualmente abilitati

###  Abilitare e disabilitare siti
```bash
ln -s /etc/nginx/sites-available/mio_sito  /etc/nginx/sites-enabled/  # Abilita un sito
nginx -t                                                              # controlla la config per errori
systemctl reload nginx

sudo rm /etc/nginx/sites-enabled/mio_sito   # Disabilita un sito = rimuove il collegamento simbolico
```
I moduli di Nginx li installo con `apt install nome_modulo` e li devo aggiungere a mano sul file di config
```bash
nano /etc/nginx/nginx.conf                           # modifico a mano la config
load_module modules/ngx_http_image_filter_module.so; # aggiungo questa riga x aggiungere il modulo
nginx -t                                             # verifico la config di Nginx
sudo systemctl reload nginx                          # ricarico Nginx per applicare le modifiche

nano /etc/nginx/nginx.conf
load_module modules/ngx_http_image_filter_module.so; # commento/elimino questa riga x eliminare il modulo
nginx -t                                             # verifico la config di Nginx
sudo systemctl reload nginx                          # ricarico Nginx per applicare le modifiche
```




