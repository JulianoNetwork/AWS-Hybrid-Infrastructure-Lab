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
  user_data_replace_on_change = true

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx

              cat > /usr/share/nginx/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html lang="en">
              <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>AWS Hybrid Infrastructure Lab</title>
                <style>
                  body {
                    margin: 0;
                    font-family: Arial, sans-serif;
                    background: #111827;
                    color: #f9fafb;
                  }

                  .container {
                    max-width: 1000px;
                    margin: auto;
                    padding: 60px 20px;
                  }

                  h1 {
                    font-size: 42px;
                    margin-bottom: 5px;
                  }

                  .subtitle {
                    color: #9ca3af;
                    margin-bottom: 40px;
                  }

                  .status {
                    display: inline-block;
                    padding: 8px 14px;
                    background: #065f46;
                    border-radius: 20px;
                    margin-bottom: 30px;
                  }

                  .grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 20px;
                  }

                  .card {
                    background: #1f2937;
                    padding: 25px;
                    border-radius: 12px;
                  }

                  .card span {
                    display: block;
                    color: #9ca3af;
                    font-size: 14px;
                    margin-bottom: 8px;
                  }

                  .card strong {
                    font-size: 20px;
                  }

                  footer {
                    margin-top: 40px;
                    color: #6b7280;
                  }
                </style>
              </head>

              <body>
                <div class="container">

                  <div class="status">● Infrastructure Online</div>

                  <h1>AWS Hybrid Infrastructure Lab</h1>
                  <p class="subtitle">
                    Infrastructure provisioned automatically using Terraform
                  </p>

                  <div class="grid">

                    <div class="card">
                      <span>Cloud Provider</span>
                      <strong>AWS</strong>
                    </div>

                    <div class="card">
                      <span>Region</span>
                      <strong>sa-east-1</strong>
                    </div>

                    <div class="card">
                      <span>Compute</span>
                      <strong>EC2 t3.micro</strong>
                    </div>

                    <div class="card">
                      <span>Operating System</span>
                      <strong>Amazon Linux 2023</strong>
                    </div>

                    <div class="card">
                      <span>Web Server</span>
                      <strong>Nginx</strong>
                    </div>

                    <div class="card">
                      <span>Infrastructure as Code</span>
                      <strong>Terraform</strong>
                    </div>

                  </div>

                  <footer>
                    AWS Hybrid Infrastructure Lab • Infrastructure as Code
                  </footer>

                </div>
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