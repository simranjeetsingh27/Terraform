resource "aws_vpc" "ninjavpc" {

  cidr_block           = var.cidrblock
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "ninja-vpc-01"
  }

}

resource "aws_internet_gateway" "ninjaigw" {
  vpc_id = aws_vpc.ninjavpc.id

  tags = {
    "Name" = "ninja-igw-01"
  }

}

resource "aws_subnet" "public_subnet" {

  count             = var.public-subnet-count
  vpc_id            = aws_vpc.ninjavpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.cidrblock, 8, count.index)

  tags = {
    "Name" = "pub-subnet-${count.index}"
  }

}


resource "aws_subnet" "private_subnet" {

  count             = var.private-subnet-count
  vpc_id            = aws_vpc.ninjavpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.cidrblock, 8, count.index + var.public-subnet-count)

  tags = {
    "Name" = "pvt-subnet-${count.index + var.public-subnet-count}"
  }

}


resource "aws_eip" "ninja_eip" {
  vpc = true

}


resource "aws_nat_gateway" "ninja_natgateway" {
  allocation_id = aws_eip.ninja_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.ninjavpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ninjaigw.id
  }

  tags = {
    "Name" = "ninja-route-pub-01"
  }

}


resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.ninjavpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ninja_natgateway.id
  }

  tags = {
    "Name" = "ninja-route-pri-01"
  }

}



resource "aws_route_table_association" "ninja-public-asspciation" {
  count          = var.public-subnet-count
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public-rt.id

}


resource "aws_route_table_association" "ninja-private-asspciation" {


  count          = var.private-subnet-count
  subnet_id      = element(aws_subnet.private_subnet.*.id, var.public-subnet-count + count.index)
  route_table_id = aws_route_table.private-rt.id

}



resource "aws_security_group" "Bastian" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ninjavpc.id


  dynamic "ingress" {

    for_each = var.web-ingress
    content {
      description = "TLS from VPC"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.port == 22 ? ["${chomp(data.http.myip.body)}/32"] : ingress.value.cidr_blocks

    }

  }
}


resource "aws_instance" "BastianServer" {
  ami           = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet[0].id
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids = [aws_security_group.Bastian.id]
  key_name = "N_virgina"
  associate_public_ip_address = true

  tags = {
    Name = "Bastian"
  }
}


resource "aws_security_group" "OSSEC" {
  name        = "OSSEC"
  description = "Allow SSH from Bastian"
  vpc_id      = aws_vpc.ninjavpc.id


  dynamic "ingress" {

    for_each = var.OSSEC-ingress
    content {
      description = "TLS from VPC"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.port == 22 ? ["${aws_instance.BastianServer.private_ip}/32"] : ingress.value.cidr_blocks

    }
  }
}

resource "aws_instance" "OSSEC-Server" {
  ami           = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private_subnet[0].id
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids = [aws_security_group.OSSEC.id]
  key_name = "N_virgina"

  tags = {
    Name = "OSSEC"
  }
}
