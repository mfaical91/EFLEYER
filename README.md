# EFLEYER
mise en œuvre d'une infra devops en se basant sur le projet efleyer


EFLEYER est une application web Dockerisée avec une chaîne CI/CD complète basée sur Jenkins. Elle est déployée automatiquement sur deux environnements : développement et production.
 CI/CD avec Jenkins


Le fichier Jenkinsfile décrit une pipeline CI/CD complète avec :

Build de l’image Docker

Push sur Docker Hub

Déploiement sur serveur de développement (develop)

Déploiement sur serveur de production (main) avec validation manuelle
