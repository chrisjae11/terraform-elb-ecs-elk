resource "aws_security_group_rule" "elk_rule" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.ecs_instance_security_group.id}"
  security_group_id = "${var.elk_sg}"
}

resource "aws_security_group" "ecs_instance_security_group" {
  name        = "ecs_instance_security_group"
  description = "Allow 8080"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}