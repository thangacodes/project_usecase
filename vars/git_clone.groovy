pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Define the repository URL
                    def gitUrl = 'https://github.com/thangacodes/k8s_cicd_project.git'

                    // Checkout code from the repository
                    git branch: 'master', url: gitUrl
                }
            }
        }
    }
}
