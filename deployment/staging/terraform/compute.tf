resource "aws_instance" "instance" {
  ami                    = var.aws_ami_id
  instance_type          = var.aws_instance_type
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = aws_subnet.subnet.id
  key_name               = aws_key_pair.key_pair.key_name
  iam_instance_profile   = aws_iam_instance_profile.instance.name
  user_data              = file("${path.module}/../scripts/setup.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "instance" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.cloudwatch.name
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "Terraform"
  public_key = tls_private_key.private_key.public_key_openssh
}
