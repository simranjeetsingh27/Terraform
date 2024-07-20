data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_availability_zones" "avilable" {
  state = "available"
}
