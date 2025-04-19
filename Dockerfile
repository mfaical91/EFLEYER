# Utiliser l'image de base officielle Nginx
FROM nginx:alpine

# Copier les fichiers de votre site dans le répertoire approprié de Nginx
COPY . /usr/share/nginx/html

# Exposer le port 80 pour que le site soit accessible
EXPOSE 80

# Lancer Nginx au démarrage
CMD ["nginx", "-g", "daemon off;"]
