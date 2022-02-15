data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
resource "aws_instance" "app_server" {
    ami           = nonsensitive(data.aws_ssm_parameter.ami.value)
    instance_type = var.instance_type
    vpc_security_group_ids = ["sg-02d65af4d09b6f2bb"]
    subnet_id = "subnet-084653feaa46384dd"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

resource "aws_instance" "example_a" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
}

resource "aws_instance" "example_b" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.example_a.id
}

