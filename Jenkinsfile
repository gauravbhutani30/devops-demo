pipeline {
   agent any
   environment {
       DOCKER_TAG = getDockerTag()
   } 
   stages {
       stage("SCM Checkout"){
	       steps{
		   git 'https://github.com/gauravbhutani30/devops-demo.git'
		   }
	   }
	   stage("Maven Build"){
	       steps {
		   sh "mvn clean install"
		   sh "mv target/*.war target/devops.war"
		 } 
      }
	 /*
	   stage("Deploy to container"){
		   steps{
		   sh "docker build . -t gauravbhutani30/devops:${DOCKER_TAG}"
		}
	  }
	  */
	   stage("Stage with input") {
    		   steps {
      def userInput = false
        script {
            def userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', 
											   defaultValue: true, 
											   description: '', 
											   name: 'Please confirm you agree with this']])
            echo 'userInput: ' + userInput

            if(userInput == true) {
               sh "docker build . -t gauravbhutani30/devops:${DOCKER_TAG}" 
            } else {
                // not do action
                echo "Action was aborted."
            }

        }    
    }  
}
	 /* stage('Push Docker Image'){
           steps {
        	withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
            sh "docker login -u gauravbhutani30 -p ${dockerHubPwd}"
        }
        	sh 'docker push gauravbhutani30/devops:${DOCKER_TAG}'
          }
      }*/
   }
}
def getDockerTag() {
          def tag = sh script: 'git rev-parse HEAD', returnStdout: true
          return tag
    }
