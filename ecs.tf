resource "aws_ecs_cluster" "aws_ecs_cluster" {
  name = "nginx_cluster"
}

data "template_file" "task_definition" {
  template = "${file("${path.module}/taskdef.tpl")}"

  vars {
    ecr_repository_url = "${aws_ecr_repository.nginx.repository_url}"
  }
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                = "nginx-task-definition"
  container_definitions = "${data.template_file.task_definition.rendered}"
}

data "aws_lb_target_group" "default" {
  arn = "${aws_lb_target_group.tf_elb_tg.arn}"
}

resource "aws_ecs_service" "nginx_service" {
  name            = "tf_nginx_service"
  cluster         = "${aws_ecs_cluster.aws_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.nginx_task.family}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.tf_elb_tg.arn}"
    container_name   = "tf-nginx-container"
    container_port   = 80
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  depends_on = ["data.aws_lb_target_group.default", "aws_instance.ecs_instance"]
}

resource "aws_instance" "ecs_instance" {
  # ECS-optimized AMI for eu-central-1
  ami = "ami-10e6c8fb"
  instance_type = "t2.micro"
  subnet_id = "subnet-c0be96ab"
  vpc_security_group_ids = ["${aws_security_group.ecs_instance_security_group.id}"]
  user_data = <<EOF
    #!/bin/bash
    echo ECS_CLUSTER=${aws_ecs_cluster.aws_ecs_cluster.name} >> /etc/ecs/ecs.config
  EOF
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.name}"
  key_name = "${var.ssh_key_name}"
}

resource "aws_ecr_repository" "nginx" {
  name = "nginx"
}

resource "null_resource" "build_push_image" {
  depends_on = ["aws_ecr_repository.nginx"]
  provisioner "local-exec" {
      command = <<EOF
        export AWS_ACCESS_KEY_ID="${var.aws_access_key}"
        export AWS_SECRET_ACCESS_KEY="${var.aws_secret_key}"
        aws ecr get-login --no-include-email --region "${var.region}" > login.sh
        source login.sh
        docker build -t nginx docker/.
        docker tag nginx:latest "${aws_ecr_repository.nginx.repository_url}":latest
        docker push "${aws_ecr_repository.nginx.repository_url}":latest
        rm -rf login.sh
      EOF
  }
}