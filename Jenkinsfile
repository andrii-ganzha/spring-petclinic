pipeline {
    agent any
    tools {
      terraform 'terraform-11'
    }
    stages {
        stage('Create task-definition') {
            steps {
                sh '''
                echo $petclinic_task_env >> petclinic-task.json
                cat petclinic-task.json
                '''
            }
        }
        
        stage('Start the application') {
          steps {
            sh '''
            terraform init
            terraform apply --auto-approve
            '''
          }
        }
    }
}