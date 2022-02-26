variable "name_prefix" {
  type = string
  default = "terraform-lc-example1"
}
variable "image_id" {
  type = string
  default = "ami-0629230e074c580f2"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "name" {
  type = string
  default = "terraform-asg-1"
}
variable "availability_zones" {
  type = list(string)
  default = ["us-east-2c"]
}
variable "name_lb" {
  type = string
  default = "test-lb-tfc"
}

variable "security_groups" {
  type = list(string)
  default = ["sg-0bb5391635b3c304e"]
}
variable "subnets" {
  type = list(string)
  default =  ["subnet-004e41b3ff4a0aa5f","subnet-0080182dff1d4159a"]
}

variable "protocol" {
  type = string
  default = "HTTP"
}
variable "vpc_id" {
  type = string
  default = "vpc-0f607673eab7d2eb7"
}
variable "target_id" {
  type = string
  default = "i-033e9c4279b6714ba"
}
variable "target_group_arns" {
   type = string
  default = ""
}




