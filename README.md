## Lab Terraform et AWS 

### Objectif :
 Déployer une architecture de haute disponibilité pour une application web à l'aide d'AWS et Terraform.

### Description :

* Créez un fichier main.tf qui contient la configuration Terraform.
* Utilisez au moins trois zones de disponibilité AWS.
* Déployez une instance EC2 dans chaque zone de disponibilité.
* Utilisez un équilibreur de charge d'application (ALB) pour répartir la charge entre les instances EC2.
* Utilisez un groupe auto-scaling pour gérer automatiquement la montée et la descente en charge des instances EC2.
* Stockez les données de l'état Terraform dans un compartiment S3.
Consignes :

### Approche 
* Commencez par définir vos fournisseurs (AWS) et la version de Terraform dans le fichier main.tf.
* Configurez un VPC avec au moins trois sous-réseaux, chacun dans une zone de disponibilité différente.
Déployez une instance EC2 dans chaque sous-réseau.
* Configurez un équilibreur de charge d'application (ALB) et associez les instances EC2.
* Mettez en place un groupe auto-scaling pour les instances EC2, en définissant des politiques de montée et descente automatiques basées sur la charge.
* Configurez un compartiment S3 pour stocker l'état Terraform de manière sécurisée.
* Utilisez des variables Terraform pour rendre votre configuration plus flexible et réutilisable.
* Ajoutez des étiquettes (tags) appropriées pour les ressources créées.
Documentez votre configuration en ajoutant des commentaires pertinents.
* Testez votre configuration en la planifiant (terraform plan) et en l'appliquant (terraform apply).
* Assurez-vous de comprendre chaque partie de votre configuration Terraform et les interactions entre les différentes ressources. Cet exercice vous aidera à pratiquer la création d'une infrastructure cloud avancée et à comprendre les concepts clés de Terraform et AWS.







subnets
security group in loadbalancer