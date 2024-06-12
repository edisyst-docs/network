# TRASMISSIONE VIA SSH

### ELENCO FILE
```bash
authorized_keys # contiene tutte le chiavi pubbliche del mio client (tutti gli host a cui può accedere)
id_rsa # la mia chiave privata
id_rsa.pub # la mia chiave pubblica che posso passare a chiunque per fare io da host a lui
known_hosts
```

### INSERIMENTO MANUALE CHIAVI
```bash
scp .ssh/id_rsa.pub utente@host: # secure copy, copio manualmente la pubkey sull'host. I : finali indicano che andrò nella home folder
Nell'host dovrò fare:
mkdir .ssh
chmod 700 .ssh/
cat id_rssa.pub >> .ssh/authorized_keys # qui copio tutte le pubkey che verranno usate
rm /id_rssa.pub
chmod 600 .ssh/authorized_keys
cat .ssh/authorized_keys
exit
Dal client se cerco di entrae in ssh mi chiede la password della chiave, non quella dell'host remoto
```

### INSERIMENTO AUTOMATICO CHIAVI
```bash
Dalla macchina host faccio:
ssh-keygen -t rsa # crea .ssh/is_rsa e .ssh/is_rsa.pub
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.10.20
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








