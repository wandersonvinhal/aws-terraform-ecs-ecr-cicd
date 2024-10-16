resource "aws_security_group" "sg_ssh_http" {
  vpc_id = aws_vpc.tcb_blog_vpc.id
  name        = "allow_ssh_http"

  ingress {
    description = "Acesso SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Acesso HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Acesso HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = aws_vpc.tcb_blog_vpc.id
  peer_vpc_id = var.ansible_vpc_id
  peer_region = var.ansible_vpc_region

  tags = {
    Name = "tcb_blog_vpc_peering"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Name = "tcb_blog_vpc_peering"
  }

  depends_on = [aws_vpc_peering_connection.peer]
}

resource "aws_route" "ansible_to_main" {
  route_table_id             = var.ansible_route_table_id
  destination_cidr_block     = var.vpc_cidr
  vpc_peering_connection_id  = aws_vpc_peering_connection.peer.id

  depends_on = [
    aws_vpc_peering_connection_accepter.peer_accepter,
    aws_vpc_peering_connection.peer
  ]
}