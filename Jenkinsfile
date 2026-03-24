pipeline {
    agent any
    
    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO = '343770680577.dkr.ecr.ap-south-1.amazonaws.com/devops-pipline'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/your-repo.git'
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
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}
                    docker push ${ECR_REPO}:latest
                '''
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                sh '''
                    ssh -i UBUNTU-KEY.pem ubuntu@ec2-13-233-155-255.ap-south-1.compute.amazonaws.com << 'EOF'
                        aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 343770680577.dkr.ecr.ap-south-1.amazonaws.com
                        docker rm -f my-app || true
                        docker pull 343770680577.dkr.ecr.ap-south-1.amazonaws.com/devops-pipline:latest
                        docker run -d -p 8080:8080 --name my-app 343770680577.dkr.ecr.ap-south-1.amazonaws.com/devops-pipline:latest
                        docker ps
                    EOF
                '''
            }
        }
    }
}
