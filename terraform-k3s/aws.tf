data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "k3s" {
  name        = "k3s"
  description = "Allow k3s traffic"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.k3s.id
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.k3s.id
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.k3s.id
}

resource "aws_security_group_rule" "allow_k3s_server" {
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k3s.id
  source_security_group_id = aws_security_group.k3s.id
}

resource "aws_security_group_rule" "allow_flannel_vxlan" {
  type                     = "ingress"
  from_port                = 8472
  to_port                  = 8472
  protocol                 = "udp"
  security_group_id        = aws_security_group.k3s.id
  source_security_group_id = aws_security_group.k3s.id
}

resource "aws_security_group_rule" "allow_flannel_wireguard" {
  type                     = "ingress"
  from_port                = 51820
  to_port                  = 51821
  protocol                 = "udp"
  security_group_id        = aws_security_group.k3s.id
  source_security_group_id = aws_security_group.k3s.id
}

resource "aws_key_pair" "tf_key" {
  key_name   = "tf-key"
  public_key = "<your-public-key>"
}

resource "aws_launch_template" "k3s" {
  name = "ks3-flux"

  # Rocky Linux 9.2
  image_id = "ami-00297d5e47600069b"

  instance_type = "t3.large"

  vpc_security_group_ids = [aws_security_group.k3s.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      terraformed = "true"
    }
  }

  user_data = filebase64("setup.sh")
}

resource "aws_instance" "k3s" {
  launch_template {
    id      = aws_launch_template.k3s.id
    version = "$Latest"
  }

  key_name = aws_key_pair.tf_key.key_name

  tags = {
    Name        = "k3s"
    terraformed = "true"
  }
}

output "ec2_global_ips" {
  value = ["${aws_instance.k3s.*.public_ip}"]
}
