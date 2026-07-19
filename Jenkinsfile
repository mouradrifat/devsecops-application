pipeline {
  agent any

    stages {
        stage('Build Artifact - Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube - SAST') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=devsecops-sonar-app -Dsonar.host.url=http://192.168.56.102:9000 -Dsonar.login=sqp_c8d7889d2e05292bd50f02d48a1a3598a4d8bfca'
                }
                timeout(time: 2, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }


        stage('Vulnerability Scan - Trivy') {
            steps {
                sh 'bash trivy-docker-image-scan.sh'
            }
        }

        stage('Vulnerability Scan - OPA Conftest') {
            steps {
                sh 'docker run --rm -v /var/lib/jenkins/workspace/devsecops-pipeline:/project -w /project openpolicyagent/conftest test --policy dockerfile-security.rego Dockerfile'
            }
        }

        stage('Docker build') {
            steps {
                sh 'docker build -t devsecops-application:${GIT_COMMIT} .'
                sh 'docker save devsecops-application:${GIT_COMMIT} -o app.tar'
                sh 'k3s ctr images import app.tar'
            }
        }

        stage('Kubernetes - Deployment DEV') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    sh 'kubectl apply -f k8s_deployment_service.yaml'
                }
            }
        }
    }
}