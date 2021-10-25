terraform {
    backend "s3" {
        bucket = "terraformbucket2510"
        encrypt = true
        key = "terraform-states/terraform.tfstate"
        region = "eu-central-1"
    }
}



provider "aws" {
    region = "eu-central-1"
}

resource "aws_ecs_service" "tf-petclinic-service" {
    name = "tf-petclinic-service"
    cluster = "tf-petclinic-cluster"
    task_definition = "${aws_ecs_task_definition.tf-petclinic-task2.arn}"
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
        subnets = ["subnet-05a79ca4f8ca098a7", "subnet-04580d47c361b9236"]
        security_groups = ["sg-00cd962ecbb43f6b5"]
        assign_public_ip = true
    }
}

resource "aws_ecs_task_definition" "tf-petclinic-task2" {
    family = "tf-petclinic-task3"
    container_definitions = "${file("petclinic-task.json")}"
    requires_compatibilities = ["FARGATE"]
    cpu = 256
    memory = 512
    network_mode = "awsvpc"
    execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
    name = "ECSTaskExecutionRolePolicy-Demo"
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
    #assume_role_policy = "${file("assume_role_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role = aws_iam_role.ecsTaskExecutionRole.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        
        principals {
            type        = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}