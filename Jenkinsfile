pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1' 
        AWS_CREDENTIALS_ID = 'awscreds' 
        EKS_CLUSTER_NAME = 'demo-eks.us-east-1.eksctl.io'
    }

    stages {
        stage('SCM') {
            steps {
                git credentialsId: 'git', url: 'https://github.com/coach4u/java-jenkins-example.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def customImage = docker.build('coachrhca/webapps')
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerid') {
                        customImage.push("${env.BUILD_NUMBER}")
                        customImage.push("latest")
                    }
                }
            }
        }

        stage('Update kubeconfig for EKS') {
            steps { 
             withAWS(credentials: "${AWS_CREDENTIALS_ID}", region: "${AWS_REGION}") {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME
                    kubectl config view
                    '''
                }
            }
        }
    


        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f /tmp/web.yml --kubeconfig /tmp/config'
            }
        }
    }
}
