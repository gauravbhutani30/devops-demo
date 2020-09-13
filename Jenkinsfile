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
		   //sh "mv target/*.war target/demo-${DOCKER_TAG}.war"
		 } 
      }
	   /*
	    stage("Upload war to Nexus") {
	         steps {
			 script{
				 def mavenPom = readMavenPom file: 'pom.xml' 
			       nexusArtifactUploader artifacts: [
				   [ 
				   artifactId: 'demo', 
				   classifier: '', 
			           file: "target/demo-${mavenPom.version}.war", 
			           type: 'war'
				   ]
				   ], 
				   credentialsId: 'nexus3', 
				   groupId: 'com.example', 
				   nexusUrl: '40.117.153.227:8081',
				   nexusVersion: 'nexus3', 
				   protocol: 'http', 
				   repository: 'devops-release', 
				   version: "${mavenPom.version}" 
			 }
	  }
	    }
	  */
	   stage("Deploy to container"){
		   steps{
		   sh "docker build . -t gauravbhutani30/devops:${DOCKER_TAG}"
		}
	  }
	  
	   /*
	   stage("Deploy to container - Manual Approval") {
    		   steps {
      //def userInput = false
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
*/
	 /* stage('Push Docker Image'){
           steps {
        	withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
            sh "docker login -u gauravbhutani30 -p ${dockerHubPwd}"
        }
        	sh 'docker push gauravbhutani30/devops:${DOCKER_TAG}'
          }
      }*/
	   stage('Deploy to Kubernetes') {
	        steps {
			    sh "chmod +x changeTag.sh"
				sh "./changeTag.sh ${DOCKER_TAG}"
				sh "cp services.yml node-app-pod.yml /opt"
				/*script {
				   try {
				   sh "kubectl -f apply ."
				  }catch(error){
				   sh "kubectl -f create ."
			      }
				}*/
			}
	  }
	  post {
        failure {
            echo 'I failed :('
    }
   }
   }
}
def getDockerTag() {
          def tag = sh script: 'git rev-parse HEAD', returnStdout: true
          return tag
    }
