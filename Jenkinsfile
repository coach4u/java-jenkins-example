pipeline {
    agent any

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

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f /tmp/web.yml --kubeconfig /tmp/config'
            }
        }
    }
}
