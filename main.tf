resource "aws_subnet" "mysubnet" {
  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = "172.31.0.0/24"

  tags = {
    Name = "admin"
  }
}

resource "aws_route_table" "admin_routetable" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = data.aws_nat_gateway.nat
  }
  tags = {
    Name = "admin"
  }
}

resource "aws_route_table_association" "admin" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.admin_routetable.id
}

resource "aws_security_group" "admin_security_group" {
  name        = "admin_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "admin_sg"
  }
}

data "archive_file" "lambda_function_archive" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_archive.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_archive.zip"
  function_name = "test_lambda"
  role          = data.aws_iam_role.lambda.arn 
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.7"

  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [aws_subnet.mysubnet.id]
    security_group_ids = [aws_security_group.admin_security_group.id]
  }

}
