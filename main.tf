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

data "aws_security_group" "petclinic_sg_final" {
    name = "petclinic_sg_final"
}

data "aws_subnet" "tf_petclinic_subneta" {
    tags = {
        Name = "tf_petclinic_subneta"
    }
} 

data "aws_subnet" "tf_petclinic_subnetb" {
    tags = {
        Name = "tf_petclinic_subnetb"
    }
} 

resource "aws_ecs_service" "tf-petclinic-service" {
    name = "tf-petclinic-service"
    cluster = "tf-petclinic-cluster"
    task_definition = "${aws_ecs_task_definition.tf-petclinic-task2.arn}"
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
        subnets = [data.aws_subnet.tf_petclinic_subneta.id, data.aws_subnet.tf_petclinic_subnetb.id]
        security_groups = [data.aws_security_group.petclinic_sg_final.id]
        assign_public_ip = true
    }
}

resource "aws_cloudwatch_log_group" "testapp_log_group" {
    name = "/ecs/testapp"
    retention_in_days = 30
    tags = {
        Name = "cw-log-group"
        }
    }
resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
    name = "test-log-stream"
    log_group_name = aws_cloudwatch_log_group.testapp_log_group.name
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
