pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REGISTRY = "343770680577.dkr.ecr.ap-south-1.amazonaws.com"
        ECR_REPOSITORY = "devops-pipline"
        IMAGE_TAG = "latest"
        INSTANCE_ID = "i-0c484beecadd7540d"   // 🔥 replace with your EC2 ID
    }

    stages {

        stage('Build Docker Image') {
            steps {
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

        stage('Deploy via SSM') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                    aws ssm send-command \
                    --instance-ids $INSTANCE_ID \
                    --document-name "AWS-RunShellScript" \
                    --comment "Deploy Docker Container" \
                    --parameters commands="
                    
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
                    
                    docker rm -f my-app || true
                    
                    docker pull $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
                    
                    docker run -d -p 8080:8080 --name my-app $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
                    
                    docker ps
                    " \
                    --region $AWS_REGION
                    '''
                }
            }
        }
    }
}
