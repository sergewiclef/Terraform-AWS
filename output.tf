output "lambda_function" {
	value = aws_lambda_function.search_lambda.qualified_arn
}