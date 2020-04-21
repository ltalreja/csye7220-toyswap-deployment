#
# EKS Cluster Resources
#  * EKS Cluster
#
#  It can take a few minutes to provision on AWS

resource "aws_eks_cluster" "toyswap" {
  name     = "${var.cluster-name}"
  role_arn = "${aws_iam_role.toyswap-cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.toyswap-cluster.id}"]
    subnet_ids         = "${aws_subnet.toyswap.*.id}"
  }

  depends_on = [
    "aws_iam_role_policy_attachment.toyswap-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.toyswap-cluster-AmazonEKSServicePolicy",
  ]
}
