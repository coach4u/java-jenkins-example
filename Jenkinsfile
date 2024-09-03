pipeline {
   environment {
   registry = "coachrhca/dockertestimage"
    registryCredential = ''
  }
  agent any
    stages {
      stage('SCM') {
        steps {
          git credentialsId: 'git', url: 'https://github.com/coach4u/java-jenkins-example.git'
        }
    }
	  stage('build') {
	    steps {
	       sh 'mvn clean'
	       sh 'mvn package'
	    }
      }
  stage('Build docker image') {
          steps {
              script {         
                def customImage = docker.build('coachrhca/webappqa',)
                docker.withRegistry('https://registry.hub.docker.com', 'dockerid') {
                 customImage.push("${env.BUILD_NUMBER}")
           }
    }
 }
}
  stages {
            stage('k8s'){
              steps{
                   sh 'kubectl create -f /tmp/web.yml --kubeconfig /tmp/config'	  
           }
          }
         }
      } 




