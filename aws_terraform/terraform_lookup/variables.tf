variable "region" {
  description = "The region where we provision the resources"
  default     = "ap-south-1"
}

variable "identification" {
  description = "All the resources that we provision via Terraform should be tied up with the tags below"
  default = {
    Environment  = "Sandbox"
    Costcenter   = "1000234"
    CreationDate = "15-08-2024"
    Owner        = "Thangadurai.murugan@cloudbird.fun"
  }
}

variable "instance_type" {
  description = "Selecting the right resource vm specification"
  default = {
    dev   = "t2.micro"       //devinstancetype
    stage = "t3.micro"      //stageinstancetype
    prod  = "t3.large"     //prodinstancetype
  }
}

variable "sshkey" {
  description = "Selecting the right ssh keypair to associated newly provisioned vm"
  default = {
    dev   = "dwebkey"    //devwebkey
    stage = "swebkey"   //stagewebkey
    prod  = "pwebkey"  //prodwebkey
  }
}
