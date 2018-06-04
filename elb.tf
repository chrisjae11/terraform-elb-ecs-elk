resource "aws_lb" "tf_elb" {
  name               = "tf-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${var.subnet_ext_id}"]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tf_elb_tg" {
  name     = "tf-lb-tg"
  port     = 8080
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"
  depends_on = ["aws_lb.tf_elb", ]
}

resource "aws_lb_listener" "lb-listener" {
    load_balancer_arn = "${aws_lb.tf_elb.arn}"
    port              = "443"
    protocol          = "TCP"

    default_action {
        target_group_arn = "${aws_lb_target_group.tf_elb_tg.arn}"
        type             = "forward"
    }
}
