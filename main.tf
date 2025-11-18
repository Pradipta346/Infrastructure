# Create VPC and Subnet-----------------------

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Golden-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "public-subnet"
  }
}

# Create Security Group-----------------------------

resource "aws_security_group" "my_sg" {
  name        = "my-terraform-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      =  aws_vpc.my-vpc.id


  # Inbound rules
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-sg"
  }
}

# Create EC2 Instance-------------------------------------

resource "aws_instance" "my-ec2" {
  ami                         = "ami-0305d3d91b9f22e84"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address  = true
  vpc_security_group_ids       = [aws_security_group.my_sg.id]
  # no key_name specified → creates instance without key pair

  tags = {
    Name = "Terraform-EC2"
  }
}

# stopped ec2

resource "aws_ec2_instance_state" "my_ec2" {
  instance_id = aws_instance.my-ec2.id
  state       = "stopped"
}

# s3-bucket--------------------------------------------

resource "aws_s3_bucket" "my-s3" {
  bucket = "my-golden-bucket-2"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# created IAM user---------------------------------------

resource "aws_iam_user" "s3_readonly_user" {
  name = "s3-readonly-user-2"
  path = "/"
  tags = {
    Purpose = "S3 ReadOnly Access"
  }
}

# IAM policy attached----------------------------------

resource "aws_iam_user_policy_attachment" "s3_readonly_policy" {
  user       = aws_iam_user.s3_readonly_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


# modules-------------------------------------------------

module "my_s3" {
  source = "./modules/s3"
}


# meta arguments - It is used in Terraform to control the resource how to create,update and destroy.

# count

resource "aws_instance" "my_ec2" {
  count = 2
  ami =  "ami-0305d3d91b9f22e84"
  instance_type = "t2.micro"
  tags = {
    Name = "webserver_${count.index}"
  }
}
 
# for each

resource "aws_instance" "ec2" {
  ami = "ami-0305d3d91b9f22e84"
  for_each = var.instance_type
  instance_type = each.value

  tags = {
    Name = "each.key"
  }
}
