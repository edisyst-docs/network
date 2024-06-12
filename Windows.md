# Windows CMD
```bash
doskey/history     # uguale a history in Linux

ping 8.8.8.8       # Opera a livello di IP ADDRESS (liv.3)
ping google.it     # Verifica se un host è attivo
pathping google.it # misura la latenza dal mio router per esempio

nslookup www.google.com   # UGUALE A LINUX: interroga i server DNS, mi dà info sulla destinazione
route  # visualizza la tabella di instradamento del mio host
arp -a # stampa la relazione IP-MAC_ADDRESS di ogni scheda di rete. Opera a livello di MAC ADDRESS (liv.2)
 
tracert google.it # mostra  tutti i salti del pacchetto per arrivare all'host remoto

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
