data "http" "myipp" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_availability_zones" "available" {
  state = "available"
}
