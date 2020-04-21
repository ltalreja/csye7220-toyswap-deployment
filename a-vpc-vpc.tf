#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "toyswap" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
      "Name", "terraform-eks-toyswap-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "toyswap" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.toyswap.id}"

  tags = "${
    map(
      "Name", "terraform-eks-toyswap-node",
      "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "toyswap" {
  vpc_id = "${aws_vpc.toyswap.id}"

  tags = {
    Name = "terraform-eks-toyswap"
  }
}

resource "aws_route_table" "toyswap" {
  vpc_id = "${aws_vpc.toyswap.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.toyswap.id}"
  }
}

resource "aws_route_table_association" "toyswap" {
  count = 2

  subnet_id      = "${aws_subnet.toyswap.*.id[count.index]}"
  route_table_id = "${aws_route_table.toyswap.id}"
}
