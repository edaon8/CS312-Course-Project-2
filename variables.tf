variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "Name of the existing AWS Key Pair to attach to the instance"
}