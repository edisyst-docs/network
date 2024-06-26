# Utenti
```bash
adduser nicola # crea utente nuovo: mi chiederà la sua password più altre info opzionali
# Esiste anche "useradd" ma è più comodo "adduser" 
adduser --home /home/utente_custom luca  # modifica la home di default di luca (sarebbe stata /home/luca)
adduser --ingroup amministratori edoardo # crea edoardo già inserito in un gruppo

w # info dettagliate sugli utenti connessi e le attività che stanno svolgendo
```


# Network
La scrittura `192.168.1.10/24` equivale a dire: `IP=192.168.1.10` e `netmask=255.255.255.0` ossia:
- i primi 24 bit identificano la rete: da `192.168.0.0` a `192.168.255.0`
- gli ultimi 8 bit identificano l'host

La scrittura `192.168.1.10/23` equivale a dire: `IP=192.168.1.10` e `netmask=255.255.254.0` ossia:
- i primi 23 bit identificano la rete: da `192.168.0.0` a `192.168.127.0` 
- gli ultimi 9 bit identificano l'host

```bash
ifconfig -a                                      # mostra tutte le interfacc, anche quelle spente 
ifconfig eth0 192.168.1.10 netmask 255.255.255.0 # imposto il mio IP statico e netmask sulla mia eth0
ifconfig eth0 hw ether 00:1A:2B:3C:4D:5E         # posso modificare anche il MAC address della mia interfaccia
ifconfig eth0 broadcast 192.168.1.255            # configuro un indirizzo IP di broadcast
ifconfig wlan0 down / up                          # per (dis)abilitare l'interfaccia (wireless x esempio) wlan0

ip address - ip -4 address # ho solo gli IPv4 
ipconfig /all        # mostra tutte le interfacce, anche quelle spente
ifconfig /displaydns # mostra la cache dei DNS memorizzata attualmente sul sistema
ifconfig /flushdns   # cancella la cache dei DNS, da fare per prevenire attacchi cache-poisoning

ipconfig | grep "Indirizzo IPv4"
ipconfig | grep IPv4 # in questo caso fa lo stesso
ifconfig | grep eth0


nmap 192.168.1.0/24     # scansione e mappatura di un'intera rete: per scoprire host e servizi su una rete
nmap 192.168.0.*        # UGUALE
nmap -sP 192.168.1.0/24 # scansione ping per vedere quali host sono attivi
nmap 192.168.1.1-254    # scansione di range di IP: da 1 a 254
nmap 192.168.0.1,2,3    # scansione di alcuni IP specifici
nmap 192.168.0.1 192.168.0.2 192.168.0.3 # UGUALE
nmap 192.168.0.* --exclude 192.168.0.2   # escludo un IP dalla rete da scansionare
nmap 192.168.0.* --excludefile /file.txt # escludo gli IP indicati nel file

nmap 192.168.1.1                # scansione singolo host: scopre le porte aperte e i servizi in esecuzione su esse
nmap -oN output.txt 192.168.1.1 # Salva l'output in formato normale
nmap -oX output.xml 192.168.1.1 # Salva l'output in formato XML

nmap -A 192.168.1.1        # scansione dettagliata che include la rilevazione del SO e la versione
nmap -p 80,443 192.168.1.1 # scansione delle sole porte 80 e 443
nmap -p 1-100 192.168.1.1  # scansione di un range di porte: da 1 a 100
nmap -Pn 192.168.1.1       # scansione silenziosa: non invia pacchetti ping
```

```bash
passwd # per cambiare la propria password
sudo useradd nick

curl https://official-joke-api.appspot.com/jokes/random > risultatocurl.html
curl -o risultatocurl.html https://official-joke-api.appspot.com/jokes/ten # UGUALE, salva su un output
curl -I https://www.google.com                              # Recupera i metadati della risposta
curl -H "Content-Type: application/json" http://example.com # aggiungo un'intestazione HTTP alla richiesta
curl -X POST https://www.techwithtim.net/                   # il metodo di default è GET
curl -X POST -d "par1=cane&par2=val2" https://www.google.com/search # posso passargli dei parametri in POST
curl -X POST -H "Content-Type: application/json" -d '{"key1":"value1", "key2":"value2"}' http://example.com/resource # gli passo dei dati in JSON
curl -u username:password http://example.com            # richiesta con autenticazione di base
curl -F "file=@/path/to/file" http://example.com/upload # carico un file su un server
curl -c cookies.txt http://example.com                  # salvo i cookie in un file
curl -b cookies.txt http://example.com                  # invio i cookie salvati in un file

wget http://example.com/file.zip                                  # scarica un file
wget -O nuovo_nome.zip http://example.com/file.zip                # scarica un file e lo rinomina
wget -c http://example.com/file.zip                               # riprende un download interrotto
wget -b http://example.com/file.zip                               # scarica in background
wget -r http://example.com/directory                              # scarica una directory intera in modo ricorsivo
wget -m --convert-links http://example.com                        # Crea un mirror di un sito web
wget -P /destinazione http://example.com/file.zip                 # specifica una directory di destinazione per il download
wget -i lista_di_file.txt                                         # scarica file elencati in un file, che contiene un elenco di URL, uno per riga.
wget --no-check-certificate https://example.com/file.zip          # ignora i certificati SSL non validi (utile per HTTPS)
wget --user=nome_utente --password=la_password http://example.com/file.zip    # richiesta con autenticazione di base

```

```bash
ufw allow 80   # abilita il traffico verso una porta (deny lo nega)
ufw allow http # UGUALE, perchè il traffico HTTP avviene nella porta 80
ufw status     # stato del firewall
ufw enable     # attiva il firewall (disable lo disabilita)
ufw limit 22   # limita il traffico sulla 22 (SSH): per prevenire attacchi brute force

ufw default deny incoming  # nega tutto il traffico in entrata
ufw default allow outgoing # permette tutto il traffico in uscita

ufw allow from 192.168.1.100 to any port 22 # permette il traffico da un IP specifico alla porta 22
ufw allow in on eth0 to any port 80 # permette il traffico sulla porta 80 solo attraverso l'interfaccia eth0
ufw allow 5000:6000/tcp # permette il traffico su un range di porte

service start/stop/status docker # avvia/stoppa il servizio docker (per esempio)
```

```bash
cat /etc/resolv.conf # elenco dei nameserver

resolvectl status # IP pubblico
```

```bash
traceroute www.google.com          # traccia il percorso che fa un pacchetto x giungere alla destinazione
tracepath -n google.com            # SIMILE, un po' più semplice
mtr www.google.com                 # è come TRACEROUTE + PING insieme: prestazioni della rete in tempo reale
mtr -r google.com > mtr_report.txt # salvo l'output in un file
whois google.com                   # tante info di dominio: registrante, DNS, contatti, server, status
whois 8.8.8.8                      # info dettagliate di rete

dig www.google.com        # interroga i server DNS, mi dà il tempo di attesa x giungere alla destinazione
dig www.google.com +short # risolve il DNS e basta
dig www.google.com +trace # mostra ogni passaggio del processo di risoluzione DNS
dig @8.8.8.8 example.com  # usa il server DNS di Google (8.8.8.8) per eseguire la query per example.com
dig www.google.com +noall +answer # mostra solo la risposta della query

nslookup                # interroga i server DNS e dà info sui nomi di dominio o indirizzi IP della destinazione
> server 8.8.8.8        # Cambia il server DNS
> set type=MX           # Cambia il tipo di query (ad esempio, A, MX, NS)
> example.com
> exit

nslookup www.google.com # restituisce l'IP di www.google.com
nslookup 8.8.8.8        # restituisce il nome di dominio associato: dns.google in questo esempio
nslookup example.com 8.8.8.8         # utilizza il server DNS 8.8.8.8 per eseguire la query per example.com
nslookup -server=8.8.8.8 example.com # UGUALE
nslookup -query=MX example.com       # cerca i record MX per example.com

host google.com                  # risolve i nomi di dominio, mi dà l'IP
host -t ns example.com           # ottiene i record NS di un dominio

iftop                            # simile a TOP, ma per monitorare in tempo reale le interfacce di rete
iftop -i eth0                    # monitora in tempo reale l'interfaccia eth0
iftop -F 192.168.1.0/24          # visualizza il traffico in entrata e in uscita separatamente
iftop -t                         # visualizza la larghezza di banda totale

tcpdump -i eth0                  # cattura e visualizza i pacchetti che transitano attraverso un'interfaccia
tcpdump -i any                   # cattura pacchetti su tutte le interfacce disponibili
tcpdump -i eth0 -w log.pcap      # salvo i pacchetti in un file per successiva analisi
tcpdump -r log.pcap              # lettura del file precedentemente salvato
tcpdump -i eth0 host 192.168.1.1 # filtra solo i pacchetti catturati da o verso un IP specifico
tcpdump -i eth0 port 80          # filtra solo i pacchettiche utilizzano una porta specifica
```

```bash
netstat        # stato di tutte le porte TCP e UDP.
netstat -l     # mostra solo le porte in ascolto
netstat -r     # stato di tutte le interfacce di rete attive
netstat -i     # statistiche delle interfacce di rete
netstat -s     # statistiche dei vari protocolli
netstat -tulpn # esistono tante opzioni, son da provare
netstat -b 5   # in 127.0.0.1:64038 c'è il PID=64038 per identificarlo se voglio killarlo
route          # VISUALIZZA/MODIFICA LA TABELLA DI ROUTING: stesso output di netstat -r

route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1 # aggiungere una rotta statica
route add default gw 192.168.1.1 # settare il default gateway
route del -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1 # eliminare la rotta alla rete 192.168.1.0/24 attraverso il GW 192.168.1.1
ss -tulpn
```

```bash
ifup / ifdown eth0 # abilita/disabilita la scheda di rete
```



# SISTEMISTICA
```bash
systemctl restart    apache2 # Riavvia un servizio
systemctl stop       nginx   # Stoppa il servizio nginx
systemctl reload     docker  # Ricarica la config di Docker
systemctl enable     docker  # Abilita Docker all'avvio 
systemctl disable    docker  # Disabilita Docker all'avvio 
systemctl is-enabled docker  # Verifica se Docker è abilitato
systemctl status     docker  # Mostra lo stato di Docker

systemctl reboot             # riavvia il sistema
systemctl poweroff           # spegni il sistema

systemctl list-units         # mostra tutti i servizi, socket, mount point (in generale Linux le chiama UNITA')
systemctl list-units --type=service # mostra solio i service
systemctl list-units  --failed      # mostra le unità fallite

journalctl           # log di systemd
journalctl -u docker # log di systemd della sola nunità Docker
journalctl -b        # log del boot corrente

service nome_servizio comando  # più vecchio di systemctl - fa le stesse cose
service apache2 restart
```



## GPG - Crittografia asimmetrica 
Esiste il pacchetto GPG (GNU Privacy Garb) su ogni distro Linux per cifrare 1 o + file
- https://www.youtube.com/watch?v=WR2FGdNkkmI
- chiave pubblica (serratura) serve per cifrare i file (la posso condividere senza problemi, così gli altri possono cifrare i file, che io con la mia chiave privata potrò aprire)
- chiave privata (chiave di casa) serve per aprire/decifrare i file
```bash
gpg # se è installato mi crea la cartella /home/nomeutente/.gnupg
gpg --full-generate-key # seleziono RSA and RSA, posso non mettere passphrase
gpg --list-keys # per leggere le mie chiavi pub
gpg --list-secret-keys # per leggere le mie chiavi priv
```
Se dovesse servire generare entropia posso fare
```bash
df -h # per vedere i dischi /dev montati
dd if=/dev/sdc of=/dev/null #input; output su /dev/null significa buttare ciò che gli si copia dentro. E' un trucco, lo usiamo nei cron ad esempio
```
Di norma poi esporto la chiave pubblica in una cartella accessibile anche agli altri utenti, 
così possono cifrarci un file e mandarcelo
```bash
gpg --export --output /tmp/chiavepubblica "nome_chiave" # esporto la pubkey in un file
cat /tmp/chiavepubblica # è cifrata, non si legge bene
gpg /tmp/chiavepubblica # dovrebbe darmi lo stesso output di --list-keys
```

La chiave può essere data a qualsiasi utente/sito (serve solo per cifrare)
```bash
useradd utente # creo un utente per provare
passwd utente  # digito la sua password
su - utente    # impersono l'utente

gpg /tmp/chiavepubblica # può leggerla perchè è una chiave pubblica
vim file-cifrato.txt     # ci scrivo qualcosa
gpg --import /tmp/chiavepubblica # la importo per usarla nella mia /home/utente/.gnupg
gpg --encrypt -r "nome_chiave" file-cifrato.txt # cifro il mio file, me lo crea nella stessa cartella
ls -la # vedo entrambi i file: il .txt.gpg sarà illeggibile se uso cat

cp file-cifrato.txt.gpg /tmp # lo metto a disposizione degli altri utenti
exit # divento root

cd /tmp
ls -la
cat file-cifrato.txt.gpg # illeggibile
gpg /tmp/file-cifrato.txt.gpg # decifro il file, crea il file decifrato
cat file-cifrato.txt # leggibile
```



