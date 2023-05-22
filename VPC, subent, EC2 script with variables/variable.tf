
variable "cidrblock" {
  default = "10.0.0.0/16"

}

variable "region" {
  default = "us-east-2"

}

variable "public-subnet-count" {
  default = "2"

}


variable "private-subnet-count" {
  default = "2"

}


variable "web-ingress" {

  default = {
 
    "22" = {
      port        = 22
      protocol    = "tcp"

    }
  }
}

variable "OSSEC-ingress" {

  default = {
    "443" = {
      port        = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
    "80" = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
    "22" = {
      port        = 22
      protocol    = "tcp"

    }
  }
}


