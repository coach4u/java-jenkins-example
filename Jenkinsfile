pipeline {
    agent any


    environment {
        SONARQUBE_ENV = 'sonar' 
        ECR_REGISTRY = '533267334585.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPO = 'dev/webapp'
        AWS_REGION = 'us-east-1'
        IMAGE_TAG = "${BUILD_ID}"
    }
    
    stages {
        stage('Clone repo') {
            steps {
                git branch: 'master', url: 'https://github.com/coach4u/java-jenkins-example.git'
            }
        }
        stage('Build') {
            steps {
                 sh 'mvn clean package'
            }
        }
 /*   
         stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(SONARQUBE_ENV) {
                    sh """
                    mvn  verify sonar:sonar \
                        -Dsonar.host.url=https://sonarwebpage.com \
                        -Dsonar.projectName=java-jenkins-example \
                        -Dsonar.projectKey=java-jenkins-example \
                        -Dsonar.projectVersion=1.0 \
                        
                    """
                }
            }
   }
      */  
    
        stage('Docker Build') {
             steps {
               // withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_cred']]) {
                    script {
                        sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                        docker build -t  ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}  .
                    """
                }
            }
        }
   //  }

        stage('Push to ECR') {
            steps {
               // withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_cred']]) {
                    script {
                    sh "docker push  ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} "
                }
            }
        }
 //    }
    
stage('Update helm Values for gitOps') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
          sh """
              sed -i 's/tag:.*/tag: "${IMAGE_TAG}"/' ./webapps/values.yaml
              git config --global user.email "coach.rhca@gmail.com"
              git config --global user.name "coach4u"
              git add ./webapps/values.yaml
              git commit -m "Update image tag to ${IMAGE_TAG} [ci skip]" || echo "No changes to commit"
              git push https://${GIT_USER}:${GIT_TOKEN}@github.com/coach4u/java-jenkins-example.git master
"""
        }
    }
}

/*
stage('Trivy Scan') {
    steps {
        sh '''
            echo "Running Trivy vulnerability scan..."
            export TMPDIR=/var/tmp
            curl -sL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl -o html.tpl
         #   trivy image --exit-code 1 --severity CRITICAL,HIGH,MEDIUM $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
            trivy image --format template --template "@html.tpl" --output trivy-report.html --severity CRITICAL,HIGH,MEDIUM \
            ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} || true 
        '''
         archiveArtifacts artifacts: 'trivy-report.html', fingerprint: true
         echo "Trivy scan completed. HTML report archived. Pipeline continues regardless of scan result."
            }
        }
    
      stage('Generate SBOM') {
            steps {
                sh '''
                    echo "Generating SBOM using Trivy..."
                    mkdir -p sbom
                    trivy image --format cyclonedx --output sbom/sbom.cdx.json ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                '''
                archiveArtifacts artifacts: 'sbom/sbom.cdx.json', fingerprint: true
                echo "SBOM generated and archived."
            }
        }
    }

*/ 
    stage('Helm Deploy to EKS') {
    steps {
     script {
     // dir('java-jenkins-example'){
       sh '''
        export AWS_REGION=us-east-1
        export KUBECONFIG=$PWD/kubeconfig
        
        aws eks update-kubeconfig --region $AWS_REGION --name my-eks-cluster --kubeconfig $KUBECONFIG
        kubectl get nodes --kubeconfig $KUBECONFIG
        pwd
        ls -l
        helm upgrade --install webapp ./webapps --set image.tag=${IMAGE_TAG} --kubeconfig $KUBECONFIG --namespace default

      '''
                    }
                }
            }
        }
    //}
    
    
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

 /*   environment {
        AWS_REGION = 'us-east-1' 
        AWS_CREDENTIALS_ID = 'awscreds' 
        EKS_CLUSTER_NAME = 'demo-eks'
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
                sh 'kubectl apply -f web.yml --kubeconfig /tmp/config'
            }

        }
    }
}
*/
