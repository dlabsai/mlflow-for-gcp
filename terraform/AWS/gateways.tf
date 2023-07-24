resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = local.tags
}


resource "aws_eip" "nat_ip_a" {
  domain   = "vpc"
  tags = local.tags
}

resource "aws_eip" "nat_ip_b" {
  domain   = "vpc"
  tags = local.tags
}

resource "aws_nat_gateway" "mlflow_nat_a" {
  allocation_id = aws_eip.nat_ip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  depends_on = [aws_internet_gateway.main]

  tags = local.tags
}

resource "aws_nat_gateway" "mlflow_nat_b" {
  allocation_id = aws_eip.nat_ip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  depends_on = [aws_internet_gateway.main]

  tags = local.tags
}