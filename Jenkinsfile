pipeline {
   agent any
   environment {
       DOCKER_TAG = getDockerTag()
   } 

   //Checkout the code from Git   
   stages {
       stage("SCM Checkout"){
	       steps{
		   git 'https://github.com/gauravbhutani30/devops-demo.git'
		   }
	   }
	
    //Build through maven and package	
	stage("Maven Build"){
	       steps {
		   sh "mvn clean install"
		   //sh "mv target/*.war target/demo-${DOCKER_TAG}.war"
		 } 
    }
/*  
    //Code Quality through SonarQube	 
	stage("SonarQube Analysis"){
	        steps {
			withSonarQubeEnv('sonar') {
			sh "mvn sonar:sonar"
		   }
		}
	}
*/
	//Upload the war file to Nexus
	stage("Upload war to Nexus") {
	          steps {
			script {
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
				   nexusUrl: '52.188.109.125:8081',
				   nexusVersion: 'nexus3', 
				   protocol: 'http', 
				   repository: 'devops-release', 
				   version: "${mavenPom.version}" 
	            }
	        }
	    }
	
        //Build the docker image 	
	stage("Build Docker Image"){
		  steps{
		   sh "docker build . -t gauravbhutani30/devops:${DOCKER_TAG}"
		}
	}
	  
/*
    //This is a working step to show the manual approval step
	 stage("Build Docker Image - Manual Approval") {
    		   steps {
                        script {
        def userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', 
											   defaultValue: true, 
											   description: '', 
											   name: 'Please confirm you agree with this']])
                         echo 'userInput: ' + userInput
		if(userInput == true) {
		       sh "docker build . -t gauravbhutani30/devops:${DOCKER_TAG}" 
		} else {
			echo "Action was aborted."
		}
       }    
      }  
    }
 */
      //Push the docker image to Docker Hub
      stage('Push Docker Image'){
                steps {
        	 withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerHubPwd')]) {
                    sh "docker login -u gauravbhutani30 -p ${dockerHubPwd}"
            }
        	sh 'docker push gauravbhutani30/devops:${DOCKER_TAG}'
            }
      }
	
       stage('Deploy to Kubernetes') {
	        steps {
	          sh "chmod +x changeTag.sh"
		  sh "./changeTag.sh ${DOCKER_TAG}"
		script {
		   try {
		sh "kubectl apply -f ."
		  } catch(error){
		sh "kubectl create -f ."
		  }
	          }
	       }
	post {
	success{
            echo 'Your Spring boot app has been successfully deployed, Please try to access the application now'
        }
        failure { 
		echo 'We have noticed some issue with the deployment, hence rolling back to the previous version...'
        sh "kubectl rollout undo deployment/springbootapp2"
        }
       }
     }
   }
}
def getDockerTag() {
          def tag = sh script: 'git rev-parse HEAD', returnStdout: true
          return tag
}
