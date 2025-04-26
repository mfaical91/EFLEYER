pipeline {
    agent any

    environment {
        REGISTRY_CREDENTIALS = credentials('dockerhub-credentials-id') // login DockerHub
        DOCKER_IMAGE = 'efleyer'
        IMAGE_NAME = 'faical194/efleyer'
        PROD_SERVER = 'ubuntu@192.168.101.140'
        PROD_PORT = '8080' // port d'exposition
    }

    stages {
        stage('Pull Latest Image Locally (Optional)') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin
                        docker pull ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Deploy to Production Server') {
            steps {
               sshagent (credentials: ['ssh-credentials-id']) {
                    script {
                        try {
                            sh """
                                ssh -o StrictHostKeyChecking=no ${PROD_SERVER} '
                                    echo "..Connexion réussie sur serveur prod..."
                                    echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin

                                    # Sauvegarder le conteneur actuel
                                    docker rename ${DOCKER_IMAGE} ${DOCKER_IMAGE}-backup || true

                                    # Pull la dernière image
                                    docker pull ${IMAGE_NAME}:latest

                                    # Démarrer le nouveau conteneur
                                    docker run -d --name ${DOCKER_IMAGE} -p ${PROD_PORT}:80 ${IMAGE_NAME}:latest

                                    # Vérification que le nouveau conteneur tourne
                                    sleep 5
                                    docker ps | grep ${DOCKER_IMAGE}
                                '
                            """
                        } catch (Exception e) {
                            echo "..Déploiement échoué. Tentative de restauration du backup..."

                            sh """
                                ssh -o StrictHostKeyChecking=no ${PROD_SERVER} '
                                    docker stop ${DOCKER_IMAGE} || true
                                    docker rm ${DOCKER_IMAGE} || true

                                    docker rename ${DOCKER_IMAGE}-backup ${DOCKER_IMAGE} || true
                                    docker start ${DOCKER_IMAGE} || true
                                '
                            """
                            error("Le déploiement a échoué. Rollback effectué.")
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo " Déploiement terminé avec succès sur serveur production."
        }
        failure {
            echo " Pipeline échoué. Rollback déclenché ou manuel requis."
        }
    }
}
