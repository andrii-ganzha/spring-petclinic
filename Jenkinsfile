pipeline {
    agent any
    tools {
      terraform 'terraform-1.0.5'
    }
    stages {
        stage('Create task-definition') {
            steps {
                sh '''
                echo $petclinic_task_env > petclinic-task.json
                cat petclinic-task.json
                '''
            }
        }
        
        stage('Start the application') {
          steps {
              withAWS(region:'eu-central-1', credentials:'aws_ecsecrec2') {
                script {
                  sh '''
                  which terraform
                  terraform init
                  terraform apply --auto-approve
                  '''
                }
              }
          }
        }
    }
}