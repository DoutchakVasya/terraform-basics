variable "region" {
  default = "us-east-1"
}

variable "rds" {
  type = map(string)
  default = {
    //new one
    "db_name"  = "rds_db_name"
    "username" = "rds_db_username"
    "password" = "rds_db_password"
  }
}

variable "aws_key" {
  type = map(string)
  default = {
    "path" = "/home/.aws/your_aws_file.pem"
    "name" = "your_aws_file"
  }
}

variable "git" {
  default = "git@github.com:link_to_your_repo.git"
}



