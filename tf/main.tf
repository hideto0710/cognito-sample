provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_cognito_user_pool" "pool" {
  name = "hideto0710-sample"

  auto_verified_attributes = [
    "email",
  ]

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
  }

  lambda_config {
    user_migration = "${aws_lambda_function.cognito_trigger_function.arn}"
  }

  lifecycle {
    ignore_changes = [
      "schema",
    ]
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "client"
  user_pool_id                         = "${aws_cognito_user_pool.pool.id}"
  allowed_oauth_flows_user_pool_client = true

  callback_urls = [
    "https://localhost:3001/",
  ]

  supported_identity_providers = [
    "COGNITO",
  ]

  allowed_oauth_flows = [
    "code",
    "implicit",
  ]

  allowed_oauth_scopes = [
    "email",
    "openid",
  ]
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "hideto0710-sample"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}

resource "aws_iam_role" "cognito_trigger_function" {
  name = "CognitoTriggerRole"

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

data "archive_file" "cognito_trigger_function" {
  type        = "zip"
  source_dir  = "../trigger/.aws-sam/build/TriggerFunction"
  output_path = "functions/trigger_function.zip"
}

resource "aws_lambda_function" "cognito_trigger_function" {
  filename         = "${data.archive_file.cognito_trigger_function.output_path}"
  function_name    = "CognitoTriggerFunction"
  role             = "${aws_iam_role.cognito_trigger_function.arn}"
  handler          = "app.handler"
  source_code_hash = "${data.archive_file.cognito_trigger_function.output_base64sha256}"
  runtime          = "nodejs8.10"
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = "${aws_iam_role.cognito_trigger_function.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}
