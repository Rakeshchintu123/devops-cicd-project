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
                    powershell '''
                        docker logout

                        $env:DOCKER_PASSWORD | docker login --username $env:DOCKER_USER --password-stdin

                        if ($LASTEXITCODE -ne 0) {
                            Write-Error "Docker Hub login failed"
                            exit 1
                        }

                        docker push "$env:DOCKER_IMAGE`:$env:BUILD_NUMBER"
                        if ($LASTEXITCODE -ne 0) {
                            Write-Error "Docker image push failed"
                            exit 1
                        }

                        docker push "$env:DOCKER_IMAGE`:latest"
                        if ($LASTEXITCODE -ne 0) {
                            Write-Error "Docker latest image push failed"
                            exit 1
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