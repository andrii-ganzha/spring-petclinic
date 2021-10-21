pipeline {
    agent any
    tools {
        terraform 'myterraform'
    }
    stages {
        stage('Create task-definition') {
            steps {
                sh '''
                echo [
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/application1",
        "awslogs-region": "eu-central-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "hostPort": 8080,
        "protocol": "tcp",
        "containerPort": 8080
      }
    ],
    "cpu": 0,
    "environment": [
      {"name" : "MYSQL_URL", "value" : "jdbc:mysql://tf-petclininc-db.ctkrneelwtgi.eu-central-1.rds.amazonaws.com:3306/petclinic?allowPublicKeyRetrieval=true&useSSL=false"},
      {"name" : "MYSQL_USER", "value" : "admin"},
      {"name" : "MYSQL_PASS", "value" : "password"}
    ],
    "mountPoints": [],
    "memoryReservation": 500,
    "volumesFrom": [],
    "image": "273714934666.dkr.ecr.eu-central-1.amazonaws.com/petclinic_repository:a1281084ead6ab580e796ed15e8e19c90da295d0",
    "name": "tf-petclinic-task3"
  }
]' >>petclinic-task.json'
                cat petclinic-task.json
                '''

            }
        }
    }
}