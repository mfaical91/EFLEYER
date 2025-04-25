  
   pipeline {
    agent any

    environment {
        REGISTRY_CREDENTIALS = credentials('dev-server-credentials') 
        IMAGE_NAME = 'faical194/efleyer'
        DOCKER_IMAGE  = 'efleyer'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        REGISTRY_URL = 'docker.io/faical194'
        PROD_SERVER = 'ubuntu@192.168.101.140'
    }

     stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Deploy to Development Dev Server ') {
            steps {
                sshagent (credentials: ['ssh-credentials-id']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${PROD_SERVER} '
                            docker pull ${IMAGE_NAME}:${IMAGE_TAG} &&
                            docker stop efleyer-dev || true &&
                            docker rm efleyer-dev || true &&
                            docker run -d --name efleyer-dev -p 8080:80 ${IMAGE_NAME}:${IMAGE_TAG}
                        '
                    """
                }
            }
        }

     
    }
}
