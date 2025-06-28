# aws variables
variable "aws_allowed_account_ids" {
  type = list(string)
}

variable "aws_max_retries" {
  type    = number
  default = 25
}

variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}
