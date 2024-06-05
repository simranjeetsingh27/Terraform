provider "aws" {
  region = "us-east-2"
}

module "VPC" {
  source = "./C:/Users/esinmsi/OneDrive - Ericsson/Personal/AWS/AWS_Assiment/Simranjeet_Aws_Asigent9/custommodules/Modules/VPC"
  vpccidr = var.vpccidrout
  vpcname = var.vpcnameout
}

module "pubSubnet" {
  source = "./C:/Users/esinsi/OneDrive - Ericsson/Personal/AWS/AWS_Assigment/Simranjeet_Aws_Assigment9/custommodules/Modules/Subnet"
  vpc_id = module.VPC.vpcid
  vpc_cidr = module.VPC.vpccidr
}

module "pvtSubnet" {
  source = "./C:/Users/esinmsi/OneDrive - Ericsson/Personal/AWS/AWS_Assigment/Simranjeet_Aws_Assigment9/custommodules/Modules/Subnet"
  vpc_id = module.VPC.vpcid
  vpc_cidr = module.VPC.vpccidr
}

module "Igw" {
  source = "./C:/Users/esinmsi/OneDrive - Ericsson/Personal/AWS/AWS_Assigment/Simranjeet_Aws_Assigment9/custommodules/Modules/internet-gw"
  igw_vpc = module.VPC.vpcid
}

module "rt-create-ng-create" {
  source = "./C:/Users/esinmsi/OneDrive - Ericsson/Personal/AWS/AWS_Assigment/Simranjeet_Aws_Assigment9/custommodules/Modules/rt-ng-associate"
  route-ig = module.Igw.igid
  route-vpc = module.VPC.vpcid
  pub-subid = module.pubSubnet.subnetidpub
  pvt-subid = module.pvtSubnet.subnetidpvt
}

module "Security-group-bashion" {
  source = "./C:/Users/esinmsi/OneDrive - Ericsson/Personal/AWS/AWS_Assigment/Simranjeet_Aws_Assigment9/custommodules/Modules/Security group"
  sg-id = module.VPC.vpcid
}

module "Security-group-private-ec2" {
  source = "./C:/Users/esinmsi/OneDrive - Ericsson/Personal/AWS/AWS_Assigment/Simranjeet_Aws_Assigment9/custommodules/Modules/Security group"
  sg-id = module.VPC.vpcid
}

module "ec2-bashian-instance"{
  source = "./C:/Users/esinmsi/OneDrive - Ericsson/Personal/AWS/AWS_Assigment/Simranjeet_Aws_Assigment9/custommodules/Modules/EC2"
  vpc_id = module.VPC.vpcid
  subnet_id = module.pubSubnet.subnetidpub[*]
  sg-basion-id = module.Security-group-bashion.sg-id
}
