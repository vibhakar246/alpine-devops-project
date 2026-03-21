pipeline {
    agent any

    environment {
        IMAGE_NAME = "alpine-devops-app"
        TAG = "latest"
    }

    stages {

        stage('Clone Repo') {
            steps {
                echo "Cloning repository..."
                git 'https://github.com/your-username/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t $IMAGE_NAME:$TAG ."
            }
        }

        stage('Run Container') {
            steps {
                echo "Running container..."
                sh "docker run -d --name alpine-container $IMAGE_NAME:$TAG"
            }
        }

        stage('Clean Up') {
            steps {
                echo "Cleaning old container..."
                sh "docker rm -f alpine-container || true"
            }
        }
    }
}
