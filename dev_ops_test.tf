provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_db_instance" "dev_ops_test_rds_east" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "dev-ops-test-rds-east"
  name                 = "dev_ops_db"
  username             = var.rds["username"]
  password             = var.rds["password"]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_instance" "dev_ops_test_instance_east" {
  ami           = "ami-00068cd7555f543d5"
  instance_type = "t2.micro"
  key_name      = var.aws_key["name"]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.aws_key["path"])
      host        = self.public_dns
    }
    inline = [
      "sudo yum -y update",
      "sudo yum install -y git",
      "sudo amazon-linux-extras install -y docker",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose"
    ]
  }
  depends_on = [aws_db_instance.dev_ops_test_rds_east]
}


