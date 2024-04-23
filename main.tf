//main.tf
# Create S3 Bucket
resource "aws_s3_bucket" "twitter-stat-project" {
  bucket = "twitter-stat-project"
}

# Upload file to S3
resource "aws_s3_object" "twitter-stat_index" {
  bucket = aws_s3_bucket.twitter-stat-project.id
  key = "index.html"
  source = "index.html"
  content_type = "text/html"
  etag = filemd5("index.html")
}

# S3 Web hosting
resource "aws_s3_bucket_website_configuration" "twitter-stat_hosting" {
  bucket = aws_s3_bucket.twitter-stat-project.id

  index_document {
    suffix = "index.html"
  }
}

# S3 public access
resource "aws_s3_bucket_public_access_block" "twitter-stat-project" {
    bucket = aws_s3_bucket.twitter-stat-project.id
  block_public_acls = false
  block_public_policy = false
}

# S3 public Read policy
resource "aws_s3_bucket_policy" "open_access" {
  bucket = aws_s3_bucket.twitter-stat-project.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "Public_access"
    Statement = [
      {
        Sid = "IPAllow"
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.twitter-stat-project.arn}/*"
      },
    ]
  })
  depends_on = [ aws_s3_bucket_public_access_block.twitter-stat-project ]
}

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
	filename          = data.archive_file.search_lambda.output_path
	role             = aws_iam_role.lambda_iam.arn
	handler          = "search_lambda.lambda_handler"
	runtime          = "python3.9"
}