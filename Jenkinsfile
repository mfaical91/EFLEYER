pipeline {
    agent any

    environment {
        IMAGE_NAME = 'faical194/efleyer'
        IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_IMAGE = 'efleyer'
        TEST_SERVER = 'ubuntu@192.168.101.138'
        REGISTRY_URL = 'docker.io/faical194'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Deploy to Development Server') {
            steps {
                sshagent (credentials: ['ssh-credentials-id']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${TEST_SERVER} '
                            docker pull ${IMAGE_NAME}:${IMAGE_TAG} &&
                            docker ps -q --filter ancestor=${IMAGE_NAME} | xargs -r docker stop || true &&
                            docker ps -q --filter ancestor=${IMAGE_NAME} | xargs -r docker rm  || true &&
                            docker run -d --name ${DOCKER_IMAGE}:latest -p 8080:80 ${IMAGE_NAME}:latest
                        '
                    """
                }
            }
        }

  
    }
}
