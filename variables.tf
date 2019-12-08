variable "region" {
  default = "us-east-1"
}
variable "rds" {
  type = map(string)
  default = {
    // example
    "username" = "rds_db_username"
    "password" = "rds_db_password"
  }
}

variable "aws_key" {
  type = map(string)
  default = {
    // example
    "path" = "/home/.aws/your_aws_file.pem"
    "name" = "your_aws_file"
  }
}



