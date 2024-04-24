//Create lambda IAM policy
data "aws_iam_policy_document" "lambda_policy" {
	statement {
		sid    = "LambdaPolicyId"
		effect = "Allow"
		principals {
			identifiers = ["lambda.amazonaws.com"]
			type        = "Service"
		}
		actions = ["sts:AssumeRole"]
	}
}

//create IAM role for lambda policy
resource "aws_iam_role" "lambda_iam" {
	name               = "lambda_iam"
	assume_role_policy = data.aws_iam_policy_document.lambda_policy.json
}

//Create an archive for the lambda function
provider "archive" {}
data "archive_file" "search_lambda" {
	type        = "zip"
	source_file = "search_lambda.py"
	output_path = "search.zip"
}

//Create a search lambda function
resource "aws_lambda_function" "search_lambda" {
	function_name    = "search_lambda"
	filename          = "search.zip"
	role             = aws_iam_role.lambda_iam.arn
	handler          = "search_lambda.lambda_handler"
	runtime          = "python3.9"
}
