provider "aws" {
  profile = "aws_user"
  region  = var.region
}

resource "aws_db_instance" "dev_ops_test_rds_east" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "dev-ops-test-rds-east"
  name                 = var.rds["db_name"]
  username             = var.rds["username"]
  password             = var.rds["password"]
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  provisioner "local-exec" {
    command = <<EOT
      git clone $GIT_LINK ../app
      sed -i "s/mysql:host=db:33061/mysql:host=$RDS_HOST/g" $CONFIG_DB_PATH
      sed -i "s/dbname=socium_db/dbname=$RDS_DB/g" $CONFIG_DB_PATH
      sed -i "s/'username' => 'root'/'username' => '$RDS_USERNAME'/g" $CONFIG_DB_PATH
      sed -i "s/'password' => 'root'/'password' => '$RDS_PASS'/g" $CONFIG_DB_PATH
      tar -czf ../app.gz ../app
    EOT
    environment = {
      GIT_LINK       = var.git
      RDS_HOST       = self.endpoint
      RDS_DB         = var.rds["db_name"]
      RDS_USERNAME   = var.rds["username"]
      RDS_PASS       = var.rds["password"]
      CONFIG_DB_PATH = "../app/config/db.php"
    }
  }
}

resource "aws_instance" "dev_ops_test_instance_east" {
  ami           = "ami-00068cd7555f543d5"
  instance_type = "t2.micro"
  key_name      = var.aws_key["name"]
  provisioner "file" {
    source      = "../app.gz"
    destination = "~/"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.aws_key["path"])
      host        = self.public_dns
    }
    inline = [
      "sudo yum -y update",
      "sudotar -xzf app.zip yum install -y git",
      "sudo amazon-linux-extras install -y docker",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "sudo systemctl start docker",
      "tar -xzf app.zip",
      "cd app/",
      "sudo docker-compose up"
    ]
  }
  depends_on    = [aws_db_instance.dev_ops_test_rds_east]
}


