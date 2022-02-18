data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
resource "aws_instance" "app_server" {
  ami           = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type = var.instance_type
  tags          = var.resource_tags
}

resource "aws_instance" "example_a" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  tags          = var.resource_tags
}

resource "aws_instance" "example_b" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  tags          = var.resource_tags
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.example_a.id
}

resource "aws_s3_bucket" "example" {
  acl = "private"
}

resource "aws_instance" "example_c" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  tags          = var.resource_tags

  depends_on = [aws_s3_bucket.example]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  #cidr = "10.0.0.0/16"
  cidr = var.vpc_cidr_block
  azs  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #public_subnets  = ["10.0.105.0/24", "10.0.106.0/24", "10.0.107.0/24"]
  private_subnets    = slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_count)
  public_subnets     = slice(var.public_subnet_cidr_blocks, 0, var.public_subnet_count)
  enable_nat_gateway = true
  #enable_vpn_gateway = false
  enable_vpn_gateway = var.enable_vpn_gateway

  tags = var.resource_tags
}
