# usage of the specific kubernetes.io/cluster/* resource tag is required for 
# EKS and Kubernetes to discover and manage compute resources

resource "aws_autoscaling_group" "toyswap" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.toyswap.id}"
  max_size             = 2
  min_size             = 1
  name                 = "terraform-eks-toyswap"
  vpc_zone_identifier  = "${aws_subnet.toyswap.*.id}"

  tag {
    key                 = "Name"
    value               = "terraform-eks-toyswap"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}
