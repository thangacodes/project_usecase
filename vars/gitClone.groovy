def call(){
  echo "Git cloning in progress"
    sh '''
         // Define the repository URL
        def gitUrl = 'https://github.com/thangacodes/k8s_cicd_project.git'
        // Checkout code from the repository
       git branch: 'master', url: gitUrl
  '''
}
