# Windows CMD
```bash
doskey/history     # uguale a history in Linux

ping 8.8.8.8       # Opera a livello di IP ADDRESS (liv.3)
ping google.it     # Verifica se un host è attivo
pathping google.it # misura la latenza dal mio router per esempio

netsh                                        # mi dice tutte le opzioni che ha
netsh wlan show networks                     # mostra  le reti wireless disponibili
netsh wlan show profiles                     # mostra chi è connesso al Wifi
netsh wlan show profile name="Edoardo"       # Mostrare un profilo preciso di rete wireless
netsh interface show interface               # mostra le interfacce di rete
netsh wlan connect name="NomeRete"           # Connettersi a una rete wireless

netsh interface ip set address name="NomeIntFace" static indirizzoIP subnetMask gateway predefinito
netsh interface ip set address name="Ethernet" static 192.168.1.10 255.255.255.0 192.168.1.1
netsh interface ip set address name="Ethernet" source=dhcp # imposta un indirizzo IP dinamico (DHCP)

netsh advfirewall firewall show rule name=all    # Mostra le regole del firewall
netsh interface ipv4 show route                  # Mostra la tabella di routing
```

```bash
nslookup www.google.com # UGUALE A LINUX: interroga i server DNS, mi dà info sulla destinazione
route                   # visualizza la tabella di instradamento del mio host

arp -a             # UGUALE A LINUX: stampa la relazione IP-MAC_ADDRESS di ogni interfaccia
arp -i eth0        # stampa la tabella ARP per un'interfaccia specifica
arp -d             # pulisce la tabella ARP (per testare se cambio la config)
arp -d 192.168.1.2 # cancella una specifica entrata ARP
arp -s 192.168.1.3 00:aa:bb:cc:dd:ee -i eth0 # aggiunge un'entrata ARP statica

tracert -d google.it # mostra  tutti i salti del pacchetto per arrivare all'host remoto

net user # elenco utenti
net user Edoardo # dettagli utente

net session # elenco dei servizi
net stop # per fermare un servizio

tasklist # elenco processi attivi su Windows
taskkill /PID 19196 # killa il processo 19196

driverquery # elenco driver del PC indicato (default: il mio)
powercfg /q # info alimentazione e risparmio energetico

cacls # partizioni NTFS
getmac # MAC address
systeminfo # info su tutto: CPU, SO, Bios, RAM, schede di rete
wmic memphysical get memorydevices # quanti slot RAM sono utilizzati. 
```
In `Gestione attività > Prestazioni > Memoria` c'è la stessa info


# Windows Powershell
```bash
clip < network.md # copia negli appunti di Windows il contenuto di quel file

net start # mi dice i servizi attivi su Windows
net stop Temi # stoppa il servizio Temi
net start Temi # lo riavvia
```
