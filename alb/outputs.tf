output "lb_hostname" {
  value = aws_lb.alb_forward.dns_name
}

## "asg_name" {
##  value = aws_autoscaling_group.asg.name
##}
