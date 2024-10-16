#IMAGEM A SER UTILIZADA NA EC2
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data "aws_route53_zone" "existing_zone" {
  name         = "__R53_DOMAIN_NAME__"
  private_zone = false
}