  
   pipeline {
    agent any

    environment {
        REGISTRY_CREDENTIALS = credentials('dev-server-credentials') 
        DOCKER_IMAGE = 'efleyer'
        IMAGE_NAME = 'faical194/efleyer'
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

        stage('Deploy to PROD Server ') {
            steps {
                sshagent (credentials: ['ssh-credentials-id']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${PROD_SERVER} '
                            docker stop ${DOCKER_IMAGE}|| true &&
                            docker rm ${DOCKER_IMAGE} || true &&
                            docker pull ${IMAGE_NAME}:${IMAGE_TAG} &&
                            docker run -d --name ${DOCKER_IMAGE} -p 8080:80 ${IMAGE_NAME}:${IMAGE_TAG}
                        '
                    """
                }
            }
        }

     
    }
}
