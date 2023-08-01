resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.main.id
  }

  tags = local.tags
}


resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_nat_gateway.mlflow_nat_a.id
  }

  tags = local.tags
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_nat_gateway.mlflow_nat_b.id
  }

  tags = local.tags
}


resource "aws_route_table_association" "private_subnet_association_a" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.private_subnet_a.id
}

resource "aws_route_table_association" "private_subnet_association_b" {
  route_table_id = aws_route_table.private_b.id
  subnet_id      = aws_subnet.private_subnet_b.id
}


resource "aws_route_table_association" "db_subnet_association_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.db_subnet_a.id
}

resource "aws_route_table_association" "db_subnet_association_b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.db_subnet_b.id
}


resource "aws_route_table_association" "public_subnet_association_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subnet_a.id
}

resource "aws_route_table_association" "public_subnet_association_b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subnet_b.id
}