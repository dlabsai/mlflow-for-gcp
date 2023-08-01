resource "aws_security_group" "allow_ingress_from_vpn_dlabs" {
  name        = "allow_ingress_from_vpn_dlabs"
  description = "Allow inbound traffic from VPN"
  vpc_id      = aws_vpc.main.id

  tags = local.tags
}

resource "aws_security_group_rule" "db_ingress" {
  type              = "ingress"
  description       = "TLS from VPN"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = [var.your_vpn]
  security_group_id = aws_security_group.allow_ingress_from_vpn_dlabs.id
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.env}-${var.app_name}-ecs-sg"
  description = "Contains all the rules for ECS"
  vpc_id      = aws_vpc.main.id

  tags = local.tags
}


resource "aws_security_group_rule" "ecs_egress_all" {
  description       = "ECS outbound"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [var.internet_cidr]
  security_group_id = aws_security_group.ecs_sg.id
}


resource "aws_security_group_rule" "ecs_ingress" {
  description              = "ECS outbound"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.env}-${var.app_name}-rds-sg"
  description = "Allow inbound from ECS"
  vpc_id      = aws_vpc.main.id

  tags = local.tags
}

resource "aws_security_group_rule" "rds_ingress" {
  description              = "ECS inbound"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.ecs_sg.id
}


resource "aws_security_group" "lb_sg" {
  name   = "lb_security_group"
  vpc_id = aws_vpc.main.id

  tags = local.tags
}

resource "aws_security_group_rule" "ingress_lb_ports" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = [var.your_vpn]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "egress_lb_ecs" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.internet_cidr]
  security_group_id = aws_security_group.lb_sg.id
}