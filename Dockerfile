# Étape 1 : Utiliser une image de base contenant Apache et Node.js
FROM node:16-buster

# Installer Apache
RUN apt-get update && apt-get install -y apache2

# Copier le code de l'application dans le container
WORKDIR /var/www/html
COPY . .

# Installer les dépendances Node.js
RUN npm install

# Exposer le port 80 pour Apache et 3000 pour Node.js
EXPOSE 80
EXPOSE 3000

# Démarrer Apache en mode foreground et l'application Node.js
CMD service apache2 start && npm start
