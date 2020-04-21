#
# EKS Cluster Resources
#  * EC2 Security Group to allow networking traffic with EKS cluster
#

resource "aws_security_group" "toyswap-cluster" {
  name        = "terraform-eks-toyswap-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.toyswap.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-toyswap"
  }
}

resource "aws_security_group_rule" "toyswap-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.toyswap-cluster.id}"
  source_security_group_id = "${aws_security_group.toyswap-node.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "toyswap-cluster-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.toyswap-cluster.id}"
  to_port           = 443
  type              = "ingress"
}