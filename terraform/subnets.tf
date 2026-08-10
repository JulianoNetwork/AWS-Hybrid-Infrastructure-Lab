resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "sa-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "public-subnet-1"
    Project     = "AWS-Hybrid-Infrastructure-Lab"
    Environment = "Lab"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.10.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name        = "private-subnet-1"
    Project     = "AWS-Hybrid-Infrastructure-Lab"
    Environment = "Lab"
  }
}