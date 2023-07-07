resource "aws_instance" "Bastion" {
  ami = "ami-0a940cb939351ccca"
  instance_type = "t2.small"
  vpc_security_group_ids = [var.sg-bashion-id]
  subnet_id = "var.subnet_id[*]"
  key_name = "n_virgina"
  associate_public_ip_address = true
  tags = {
    Name = "bastion"
  }
}
