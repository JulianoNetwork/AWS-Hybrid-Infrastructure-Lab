data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ec2_lab" {
  name        = "hybrid-lab-ec2-public-sg"
  description = "Temporary public EC2 security group for lab"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "hybrid-lab-ec2-public-sg"
    Project     = "AWS-Hybrid-Infrastructure-Lab"
    Environment = "Lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_lab_http" {
  security_group_id = aws_security_group.ec2_lab.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Temporary HTTP access for lab validation"
}

resource "aws_vpc_security_group_egress_rule" "ec2_lab_all" {
  security_group_id = aws_security_group.ec2_lab.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}

resource "aws_instance" "web_lab" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_lab.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx

              cat > /usr/share/nginx/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>AWS Hybrid Infrastructure Lab</title>
              </head>
              <body>
                  <h1>AWS Hybrid Infrastructure Lab</h1>
                  <p>EC2 provisioned automatically with Terraform.</p>
                  <p>Amazon Linux 2023 + Nginx</p>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name        = "hybrid-lab-web"
    Project     = "AWS-Hybrid-Infrastructure-Lab"
    Environment = "Lab"
  }
}