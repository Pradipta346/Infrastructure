variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  default     = "10.0.1.0/24"
  description = "CIDR block for the public subnet"
  type        = string
}

# for each meta arguments

variable  "instance_type" {
  default = {
    "webserver-0" = "t2.micro"
    "webserver-1" = "t2.small"
    "webserver-2" = "t2.medium"
  }
}