

# Network
```bash
ifconfig - (ipconfig) - # eth0 è la mia connessione fisica a internet 
ifconfig eth0 192.168.1.10 netmask 255.255.255.0 # imposto il mio IP e netmask sulla mia eth0
ifconfig eth0 down / up # per buttare giù o ritirare su l'interfaccia eth0

ip address - ip -4 address # ho solo gli IPv4 
ipconfig /all        # mostra tutte le interfacce, anche quelle spente
ifconfig /displaydns # mostra la cache dei DNS memorizzata attualmente sul sistema
ifconfig /flushdns   # cancella la cache dei DNS, da fare per prevenire attacchi cache-poisoning

ipconfig | grep "Indirizzo IPv4"
ipconfig | grep IPv4 # in questo caso fa lo stesso
ifconfig | grep eth0
```

```bash
passwd # per cambiare la propria password
sudo useradd nick

curl https://official-joke-api.appspot.com/jokes/random > risultatocurl.html
curl -o risultatocurl.html https://official-joke-api.appspot.com/jokes/ten # stessa cosa, stampa su un output
curl -I https://www.google.com # Mi dà i metadati
curl -X POST https://www.techwithtim.net/ # il metodo di default è GET
curl -X POST --data "q=cane&par2=val2" https://www.google.com/search # posso passargli dei parametri in POST

sudo ufw allow 80
sudo ufw status
sudo ufw enable

service start/stop/status docker # avvia/stoppa il servizio docker (per esempio)
```

# SSH
```bash
sudo systemctl status ssh.service # nella macchina host dovrei verificare che SSH sia attivo

ssh-keygen -b 4096 -C "$(whoami)@$(hostname)" # -C per identificarla con un commento e ci scrivo utente@host
ssh-copy-id username@ip_macchina # invia la pub_key all'host remoto così ci potremo collegare in SSH

ssh 172.10.20.30 # di default l'utente che accede alla macchina host è lo stesso della macchina client
ssh username@ip_macchina # di default port=22, sarebbe meglio cambiarla per la sicurezza
```

```bash
cat /etc/resolv.conf # elenco dei nameserver

netsh # mi dice tutte le opzioni che ha
netsh wlan show profiles # mostra chi è connesso al Wifi

resolvectl status # IP pubblico
```

## Windows CMD
```bash
wmic memphysical get memorydevices # quanti slot RAM sono utilizzati. 
# Su Gestinoe attività > Prestazioni > Memoria c'è la stessa info

ping 8.8.8.8       # Opera a livello di IP ADDRESS (liv.3)
ping google.it     # Verifica se un host è attivo
pathping google.it # misura la latenza dal mio router per esempio

route  # visualizza la tabella di instradamento del mio host
arp -a # stampa la relazione IP-MAC_ADDRESS di ogni scheda di rete. Opera a livello di MAC ADDRESS (liv.2)
 
tracert google.it # mostra a video tutti i salti del pacchetto per arrivare all'host remoto

net user # elenco utenti
net user Edoardo # dettagli utente

net session # elenco dei servizi
net stop # per fermare un servizio
```

```bash
tasklist # elenco processi attivi su Windows
taskkill /PID 19196 # killa il processo 19196
driverquery # elenco driver del PC indicato (default: il mio)
powercfg /q # info alimentazione e risparmio energetico
cacls # partizioni NTFS
getmac # MAC address
systeminfo # info su tutto: CPU, SO, Bios, RAM, schede di rete
```

```bash
doskey/history # uguale a history in Linux
traceroute www.google.com # traccia il percorso che fa un pacchetto x giungere alla destinazione
dig www.google.com      # interrroga i server DNS, mi dà il tempo di attesa x giungere alla destinazione
nslookup www.google.com # interrroga i server DNS, mi dà info sulla destinazione
```

```bash
netstat        # stato di tutte le porte TCP e UDP.
netstat -r     # stato di tutte le interfacce di rete attive
netstat -tulpn # esistono tante opzioni, son da provare
netstat -b 5   # in 127.0.0.1:64038 c'è il PID=64038 per identificarlo se voglio killarlo
ss -tulpn
```

```bash
ifup / ifdown eth0 # abilita/disabilita la scheda di rete
```

## Powershell
```bash
clip < network.md # copia negli appunti di Windows il contenuto di quel file
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



