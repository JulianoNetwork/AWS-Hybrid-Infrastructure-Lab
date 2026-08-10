resource "aws_security_group" "alb" {
  name        = "hybrid-lab-alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "hybrid-lab-alb-sg"
    Project     = "AWS-Hybrid-Infrastructure-Lab"
    Environment = "Lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP from Internet"
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic"
}


resource "aws_security_group" "ec2" {
  name        = "hybrid-lab-ec2-sg"
  description = "Security Group for private EC2 instances"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "hybrid-lab-ec2-sg"
    Project     = "AWS-Hybrid-Infrastructure-Lab"
    Environment = "Lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_http_from_alb" {
  security_group_id = aws_security_group.ec2.id

  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP only from ALB"
}

resource "aws_vpc_security_group_egress_rule" "ec2_all" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic"
}