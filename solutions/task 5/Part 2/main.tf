provider "aws" {
  access_key = "???"
  secret_key = "???"
  region = var.region
}

resource "aws_instance" "Udacity_T2" {
  count = "4"
  ami = var.ami
  instance_type = "t2.micro"
  tags = {
    Name = "Udacity T2"
  }
  subnet_id = var.subnet_id
}

# resource "aws_instance" "udacity_m4" {
#   count = "2"
#   ami = var.ami
#   instance_type = "m4.large"
#   tags = {
#     Name = "Udacity M4"
#   }
#   subnet_id = var.subnet_id
# }

# Provides an IAM role
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Provides a Lambda Function resource
resource "aws_lambda_function" "greet_lambda_function" {
  filename      = "greet_lambda.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "greet_lambda.lambda_handler"

  source_code_hash = filebase64sha256("greet_lambda.zip")

  runtime = "python3.8"

  environment {
    variables = {
      greeting = "Hello, Udacity!"
    }
  }
}

# Provides a CloudWatch Log Group resource
resource "aws_cloudwatch_log_group" "greet_lambda_cloudwatch_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.greet_lambda_function.function_name}"
  retention_in_days = 7
}

# Provides an IAM policy
resource "aws_iam_policy" "lambda_logging_iam_policy" {
  name        = "lambda_logging_iam_policy"
  path        = "/"
  description = "A IAM policy for logging from a Lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attaches a Managed IAM Policy to an IAM role
resource "aws_iam_role_policy_attachment" "lambda_logging_iam_role_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging_iam_policy.arn
}
