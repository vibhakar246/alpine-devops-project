pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO = '343770680577.dkr.ecr.ap-south-1.amazonaws.com/devops-pipline'
    }

    stages {

        stage('Build App') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${ECR_REPO}:latest .
                '''
            }
        }

        stage('Push to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
                    sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin 343770680577.dkr.ecr.ap-south-1.amazonaws.com

                    docker push ${ECR_REPO}:latest
                    '''
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh '''
                docker pull ${ECR_REPO}:latest
                docker stop my-app || true
                docker rm my-app || true
                docker run -d -p 8081:8080 --name my-app ...
                '''
            }
        }
    }
}
