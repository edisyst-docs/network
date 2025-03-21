# TRASMISSIONE VIA SFTP
Utilizza la crittografia SSH per garantire che i dati trasferiti siano protetti
```bash
sftp [opzioni] [utente@]host[:percorso]
sftp utente@192.168.1.100
sftp -P 2222 utente@192.168.1.100 # seleziono nua porta diversa

```
Una volta connessi, dalla shell di SFTP posso lanciare i classici comandi (ls, cd, mkdir, ecc.)
```bash
sftp> get nome_file                  # Scarica file dal server remoto al mio locale
sftp> get nome_file nome_file_locale # UGUALE rinominandolo in locale 
sftp> put nome_file                  # Invia un file dal mio locale al server remoto
sftp> put nome_file nome_file_remoto # UGUALE rinominandolo nel server remoto

sftp> mget *.txt                     # Scarica più file dal remoto al locale (può usare caratteri jolly)
sftp> mput *.txt                     # Invia più file dal locale al server remoto

sftp> rename vecchio_nome nuovo_nome # Rinomina un file sul server remoto
sftp> chmod 644 nome_file            # Cambia i permessi di un file sul server remoto
sftp> quit / exit                    # Esci da SFTP
```


# TRASMISSIONE VIA SSH
```bash
sudo systemctl status ssh.service # nella macchina host dovrei verificare che SSH sia attivo

ssh-keygen -b 4096 -C "$(whoami)@$(hostname)" # -C per identificarla con un commento e ci scrivo utente@host
ssh-keygen -t ed25519            # posso specificare il type di chiave
ssh-copy-id username@ip_macchina # invia la pub_key all'host remoto così ci potremo collegare in SSH
ssh-copy-id -i ~/.ssh/id_rsa.pub ip_macchina # UGUALE IN TEORIA

ssh 172.10.20.30 # di default l'utente che accede alla macchina host è lo stesso della macchina client
ssh username@172.10.20.30      # di default port=22, sarebbe meglio cambiarla per la sicurezza
ssh -p 2222 alice@192.168.1.10 # così uso la porta 2222
ssh alice@192.168.1.10 'ls -l /var/www'     # esegue un comando sul server remoto
ssh -L 8080:localhost:80 alice@192.168.1.10 # inoltra la porta 8080 del mio locale alla 80 del server remoto
```

### ELENCO FILE DENTRO ~/.ssh
```bash
authorized_keys # contiene tutte le chiavi pubbliche del mio client (tutti gli host a cui può accedere)
id_rsa # la mia chiave privata
id_rsa.pub # la mia chiave pubblica che posso passare a chiunque per fare io da host a lui
known_hosts
```

### INSERIMENTO MANUALE CHIAVI
```bash
scp file.txt alice@192.168.1.10:/home/alice/ # utilizzo SSH per copiare file dal mio locale al server remoto
scp .ssh/id_rsa.pub utente@host: # secure copy, copio manualmente la pubkey sull'host. I : finali indicano che andrò nella home folder
```

Nell'host dovrò fare:
```bash
mkdir .ssh
chmod 700 .ssh/
cat id_rsa.pub >> .ssh/authorized_keys # qui copio tutte le pubkey che verranno usate
rm /id_rsa.pub
chmod 600 .ssh/authorized_keys
cat .ssh/authorized_keys
exit
```
Dal client se cerco di entrae in ssh mi chiede la password della chiave, non quella dell'host remoto

### INSERIMENTO AUTOMATICO CHIAVI
Dalla macchina host faccio:
```bash
ssh-keygen (-t rsa ) # crea .ssh/id_rsa e .ssh/id_rsa.pub
ssh-copy-id (-i ~/.ssh/id_rsa.pub) root@192.168.10.20 
```
Quest'ultimo comando copia il mio `.ssh/id_rsa.pub` in `~/.ssh/authorized_keys` dell'host remoto.  
Da ora in poi sarà permessa l'autenticazione senza password sull'host remoto


# COMANDO IP e opzioni
ip [opzione] [oggetto] [comando] [argomenti]

```shell
ip -4 address # ho solo gli IPv4
ip address    # UGUALE: gestisce gli indirizzi IP sulle interfacce
ip link       # Gestisce le interfacce di rete
ip route      # Gestisce le tabelle di routing
ip neigh      # Gestisce le tabelle ARP
ip rule       # Gestisce le regole di routing

ip addr add 192.168.1.10/24 dev eth0 # aggiunge l'IP all'interfaccia eth0
ip addr del 192.168.1.10/24 dev eth0 # rimuove l'IP dall'interfaccia eth0
ip route add 192.168.1.0/24 via 192.168.1.1 # aggiunge una rotta alla rete 192.168.1.0/24 attraverso il gateway 192.168.1.1
```



# Esercizio IP - Simulazione ping - WSL Linux
Per simulare la comunicazione tra due o più host con differente IP su un sistema operativo Ubuntu senza usare macchine virtuali, 
puoi utilizzare dei namespace di rete (network namespaces). 
I namespace di rete sono una funzionalità del kernel Linux che permette di isolare completamente l'ambiente di rete 
di un set di processi. Ogni namespace di rete ha le sue proprie interfacce di rete, tabelle di routing, regole firewall, ecc.

```shell
ip netns exec host_1 ping 192.168.100.2 # inizialmente mi darà per forza errore
```

### Crea i namespace di rete
```shell
ip netns add host_1
ip netns add host_2

ip netns # verifico la creazione
ip netns list # stessa cosa
```

### Crea delle veth pairs (virtual ethernet pair)
La `veth pair` è un dispositivo virtuale di rete che simula un cavo di rete con due estremità.
```bash
ip link add veth_1   type veth   peer name veth_2 # veth_1 e veth_2 sono 2 interfacce gemelle collegate fra loro
ip link show type veth # verifica se è stata creata
```

### Assegna le veth pairs ai namespace
```bash
ip link set veth_1 netns host_1
ip link # la prima è collegata a host_1
ip link set veth_2 netns host_2
ip link # entrambe collegate

ip netns exec host_1 ip link list # verifica che sia assegnata correttamente
ip netns exec host_2 ip link list # verifica che sia assegnata correttamente
```

### Configura le interfacce di rete all'interno dei namespace e assegna loro indirizzi IP
```shell
ip netns exec host_1    ip addr add    192.168.100.1/24 dev veth_1
ip netns exec host_2    ip addr add    192.168.100.2/24 dev veth_2
ip netns # risultano entrambe

ip netns exec host_1 ip addr show dev veth_1 # verifica la configurazione degli indirizzi IP
ip netns exec host_2 ip addr show dev veth_2 # verifica la configurazione degli indirizzi IP
```

### Attiva le interfacce di rete all'interno dei namespace
```bash
ip netns exec host_1 ip link set veth_1 up
ip netns exec host_2 ip link set veth_2 up

ip netns exec host_1 ip link show dev veth_1 # verifica che le interfacce siano attive
ip netns exec host_2 ip link show dev veth_2 # verifica che le interfacce siano attive
```

### Configura le interfacce di loopback all'interno dei namespace
```bash
ip netns exec host_1 ip link set lo up
ip netns exec host_2 ip link set lo up

ip netns exec host_1 ip link show dev lo # Verifica che le interfacce di loopback siano attive
ip netns exec host_2 ip link show dev lo # Verifica che le interfacce di loopback siano attive
```

### Testa la connessione con un ping
```bash
ip netns exec host_1 ping 192.168.100.1 # dovrei vedere le risposte del ping.
nmap -sn 192.168.100.0/24               # dovrei vedere tutti gli IP occupati, fa un "ping scan"
```
Questo metodo permette di simulare facilmente la comunicazione di rete tra host diversi su un singolo sistema Ubuntu 
senza la necessità di creare macchine virtuali, utilizzando le funzionalità avanzate di rete del kernel Linux.


# Rimozione degli Host
Alla fine dell'esperimento, puoi rimuovere i `namespace` e le `veth pairs` create con i seguenti comandi:

### Rimuovi le veth pairs
```bash
ip netns exec host_1 ip link delete veth_1 # basta rimuoverne uno
ip link show type veth                    # non dovrebbero più essercene 
```

### Rimuovi i namespace di rete
```bash
ip netns del host_1
ip netns del host_2

ip netns list # verifica che i namespace siano stati rimossi
```








