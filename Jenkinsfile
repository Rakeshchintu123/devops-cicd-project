pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rakeshvijay8413/devops-cicd-app"
        PYTHON = "C:\\Users\\RAKESH\\AppData\\Local\\Programs\\Python\\Python313\\python.exe"
    }

    stages {

        stage('Check Python') {
            steps {
                bat '"%PYTHON%" --version'
                bat '"%PYTHON%" -m pip --version'
            }
        }

        stage('Test') {
            steps {
                bat '"%PYTHON%" -m pip install -r app\\requirements.txt'
                bat '"%PYTHON%" -m py_compile app\\app.py'
            }
        }

        stage('Docker Check') {
            steps {
                bat 'docker --version'
                bat 'docker info'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t %DOCKER_IMAGE%:%BUILD_NUMBER% .'
                bat 'docker tag %DOCKER_IMAGE%:%BUILD_NUMBER% %DOCKER_IMAGE%:latest'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    bat '''
                        docker logout

                        echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USER% --password-stdin

                        if errorlevel 1 (
                            echo Docker Hub login failed
                            exit /b 1
                        )

                        docker push %DOCKER_IMAGE%:%BUILD_NUMBER%

                        if errorlevel 1 (
                            echo Docker image push failed
                            exit /b 1
                        )

                        docker push %DOCKER_IMAGE%:latest

                        if errorlevel 1 (
                            echo Docker latest image push failed
                            exit /b 1
                        }

                        docker logout
                    '''
                }
            }
        }

        stage('Terraform') {
            steps {
                bat 'terraform --version'
                bat 'terraform init'
                bat 'terraform validate'
                bat 'terraform plan'
            }
        }

        stage('Kubernetes Check') {
            steps {
                bat '''
                    kubectl version
                    kubectl config current-context
                    kubectl cluster-info
                    kubectl get nodes
                '''
            }
        }

        stage('Deploy Kubernetes') {
            steps {
                bat '''
                    kubectl apply -f kubernetes\\deployment.yaml --validate=false
                '''
            }
        }

        stage('Update Kubernetes Image') {
            steps {
                bat '''
                    kubectl set image deployment/devops-app devops-app=%DOCKER_IMAGE%:%BUILD_NUMBER%
                    kubectl rollout status deployment/devops-app --timeout=120s
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                bat '''
                    kubectl get deployment devops-app
                    kubectl get pods
                    kubectl get svc
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }

        failure {
            echo 'CI/CD Pipeline failed!'
        }
    }
}