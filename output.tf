output "dev_ops_test_rds_endpoint" {
  value = aws_db_instance.dev_ops_test_rds_east.endpoint
}

output "dev_ops_test_rds_address" {
  value = aws_db_instance.dev_ops_test_rds_east.address
}

output "dev_ops_test_aws_instance_public_dns" {
  value = aws_instance.dev_ops_test_instance_east.public_dns
}