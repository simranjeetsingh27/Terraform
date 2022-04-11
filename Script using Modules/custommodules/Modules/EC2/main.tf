resource "aws_instance" "Bastion" {
  ami = "ami-0a940cb939351ccca"
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.sg-basion-id]
  subnet_id = "var.subnet_id[*]"
  key_name = "N_virgina"
  associate_public_ip_address = true
  tags = {
    Name = "bastion"
  }
}