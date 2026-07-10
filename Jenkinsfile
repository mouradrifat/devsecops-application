pipeline {
  agent any

  stages {
      stage('Unit Tests') {
            steps {
              sh "mvn test"
            }
            post {
              always {
                junit '**/target/surefire-reports/*.xml'
                jacoco execPattern: '**/target/jacoco.exec', classPattern: '**/target/classes', sourcePattern: '**/src/main/java', exclusionPattern: ''
              }
            }
        }   
    }
}