data "aws_nat_gateway" "nat" {
  id = "nat-0f361f0a233d9d8af"
}

data "aws_vpc" "vpc" {
  id = "vpc-098fca400e0cb6acb"
  #cidr_block = 172.31.0.0/16
}

data "aws_iam_role" "lambda" {
  name = "aws_lambda_task_role"
}
