pipeline {
    agent any

    parameters {
        string(name: 'AWS_CREDENTIAL_ID', defaultValue: 'markwang access', description: 'The ID of the AWS credentials to use')
        string(name: 'S3_BUCKET', defaultValue: 'markwangbucket', description: 'The name of the S3 bucket to deploy to')
        string(name: 'GIT_BRANCH', defaultValue: 'main', description: 'The Git branch to build and deploy')
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-southeast-2'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the specified branch
                    checkout([$class: 'GitSCM', branches: [[name: params.GIT_BRANCH]], userRemoteConfigs: [[url: 'https://github.com/shangchewang/DevOps-Techscrum.fe.git']]])
                }
            }
        }

        stage('Build') {
            steps {
                // Install dependencies and build the application
                sh 'npm install --force'
                sh 'cp .env.example .env '
                sh 'npm run build'
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',   
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY', 
                        credentialsId: params.AWS_CREDENTIAL_ID]
                    ]) {
                    script {
                        // Assuming our build artifacts are in the 'build/' directory
                        sh "aws s3 sync build/ s3://${params.S3_BUCKET}/"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
            slackSend (color: '#00FF00', message: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
        failure {
            echo 'Deployment failed!'
            slackSend (color: '#ff3700', message: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
    }
}
