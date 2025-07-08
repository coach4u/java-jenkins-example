pipeline {
    agent any

    environment {
        SONARQUBE_ENV = 'sonar' 
    }
    
    stages {
        stage('Clone repo') {
            steps {
                git branch: 'sonar', url: 'https://github.com/coach4u/java-jenkins-example.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(SONARQUBE_ENV) {
                    sh """
                    mvn clean verify sonar:sonar \
                        -Dmaven.test.skip=true \
                        -Dmaven.test.failure.ignore=true \
                        -Dsonar.host.url=http://44.212.8.139:9000/ \
                        -Dsonar.projectName=webgoat \
                        -Dsonar.projectKey=webgoat \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.exclusions=**/*.ts
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo 'Build and analysis completed successfully.'
        }
        failure {
            echo 'Build or analysis failed.'
        }
        always {
            cleanWs()  // Clean up the workspace after the build
        }
    }
}
