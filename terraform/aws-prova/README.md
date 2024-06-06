# AWS Prova
Il file `terraform/aws-prova/terraform.tfvars` sovrascrive i valori di default dichiarati 
nel file `terraform/aws-prova/variables.tf`, il quale viene letto dal `main.tf` per
valorizzare i vari campi `var.nome_variabile` al suo interno. 
Così non devo modificare in continuazione il `main.tf` se voglio fare scaling dell'infrastruttura

