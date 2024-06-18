resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = aws_subnet.subnet.id
  key_name               = aws_key_pair.key_pair.key_name
  user_data              = file("${path.module}/assets/entrypoint.sh")

  provisioner "file" {
    source      = "${path.module}/assets/docker-compose.yaml"
    destination = "/home/ec2-user/docker-compose.yaml"
  }

  provisioner "file" {
    source      = "${path.module}/assets/nginx"
    destination = "/home/ec2-user/nginx"
  }

  provisioner "file" {
    source      = "${path.module}/assets/certbot"
    destination = "/home/ec2-user/certbot"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = tls_private_key.private_key.private_key_pem
    timeout     = "1m"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "Terraform"
  public_key = tls_private_key.private_key.public_key_openssh
}
