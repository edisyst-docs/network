# Terraform - Installazione su Docker
```shell
docker run -it hashicorp/terraform:latest # la cosa + veloce: un container Terraform
```

### Passo 1: Esegui un Container con Terraform
```shell
docker run -it --name=terraform hashicorp/terraform:latest # avvia un container Terraform
```

### Passo 2: Montare una Directory Locale
Per rendere più pratico Terraform, conviene montare una directory locale del tuo computer all'interno del container. 
In questo modo, potrai salvare e modificare i file di config Terraform sul tuo sistema host.
```bash
mkdir C:\laragon\www\network\terraform\project
```
Esegui il container Docker montando la directory locale:
```bash
docker run -it --name=terraform -v C:\laragon\www\network\terraform\project:/workspace hashicorp/terraform:0.15.4-alpine
docker run -it --name=terraform -v C:\laragon\www\network\terraform\project:/workspace hashicorp/terraform:latest tail -f /dev/null
```

### Passo 3: Creare e Eseguire Configurazioni Terraform
Nella directory montata `terraform\project` crea il file `main.tf`. 
```terraform
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

Da adesso entro nel container Terraform e lanciare i suoi comandi
```bash
docker exec -it terraform bash
```

```bash
terraform init  # inizializza il progetto Terraform
terraform plan  # esegue il piano di esecuzione
terraform apply # applica la config
terraform apply -var "instance_name=MiaIstanzaCustom" # posso sovrascrivere i default delle variabili dichiarate

terraform state   # legge il terraform.tfstate generato che è versionato x tutelarlo dai conflitti di chi lo edita
terraform output  # legge il output.tf dove gli dico quali dati restituirmi in output

terraform destroy # distrugge l'elemento creato
```

Posso introdurre un file `variables.tf` contenente delle variabili che poi richiamo nel `main.tf`, così non lo modifico