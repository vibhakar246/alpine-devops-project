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
                echo "Building Docker image..."
                sh 'docker build -t devops-pipeline .'
            }
        }

        stage('Tag Image') {
            steps {
                sh '''
                docker tag devops-pipeline:latest $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
                '''
            }
        }

        stage('Login to ECR') {
            steps {
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
                sh '''
                docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@$EC2_HOST "

                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_REGISTRY &&

                    docker rm -f my-app || true &&

                    docker pull $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG &&

                    docker run -d -p 8080:8080 --name my-app \
                    $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
                    "
                    '''
                }
            }
        }
    }
}
