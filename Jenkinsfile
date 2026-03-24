pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REGISTRY = "343770680577.dkr.ecr.ap-south-1.amazonaws.com"
        ECR_REPOSITORY = "devops-pipline"
        IMAGE_TAG = "latest"
        EC2_HOST = "13.233.155.255"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                echo "🚀 Building Docker image..."
                sh 'docker build -t devops-pipeline .'
            }
        }

        stage('Tag Image') {
            steps {
                echo "🏷️ Tagging Docker image..."
                sh '''
                docker tag devops-pipeline:latest $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                echo "🔐 Logging into AWS ECR..."
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_REGISTRY
                    '''
                }
            }
        }

        stage('Push to ECR') {
            steps {
                echo "📤 Pushing image to ECR..."
                sh '''
                docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo "🚀 Deploying to EC2..."
                sshagent(['ec2-ssh-key']) {
                    sh '''
                    ssh -tt -o StrictHostKeyChecking=no ubuntu@$EC2_HOST << EOF

                    set -e

                    echo "✅ Connected to EC2"

                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_REGISTRY

                    echo "🧹 Removing old container..."
                    docker rm -f my-app || true

                    echo "⬇️ Pulling latest image..."
                    docker pull $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

                    echo "🚀 Starting container..."
                    docker run -d -p 8080:8080 --name my-app \
                    $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

                    echo "📦 Running containers:"
                    docker ps

                    exit
                    EOF
                    '''
                }
            }
        }
    }
}
