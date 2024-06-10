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
}
}

