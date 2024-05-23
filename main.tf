//main.tf
# Create S3 Bucket for the static website
resource "aws_s3_bucket" "Email-App-SMW" {
  bucket = "Email-App-SMW"
}

# Upload index file to S3
resource "aws_s3_object" "Email-Index" {
  bucket = aws_s3_bucket.Email-App-SMW.id
  key = "index.html"
  source = "index.html"
  content_type = "text/html"
  etag = filemd5("index.html")
}

# Upload CSS file to S3
resource "aws_s3_object" "Email-CSS" {
  bucket = aws_s3_bucket.Email-App-SMW.id
  key = "style.css"
  source = "style.css"
  content_type = "text/css"
  etag = filemd5("style.css")
}

# Upload error file to S3
resource "aws_s3_object" "Email-Error" {
  bucket = aws_s3_bucket.Email-App-SMW.id
  key = "error.html"
  source = "error.html"
  content_type = "text/html"
  etag = filemd5("error.html")
}

# S3 Web hosting
resource "aws_s3_bucket_website_configuration" "Email-App-SMW-Hosting" {
  bucket = aws_s3_bucket.Email-App-SMW.id
  
  index_document {
    suffix = "index.html"
  
  }
  error_document {
    key = "error.html"
  }
}

# S3 public access
resource "aws_s3_bucket_public_access_block" "Email-App-SMW" {
    bucket = aws_s3_bucket.Email-App-SMW.id
  block_public_acls = false
  block_public_policy = false
}

# S3 public Read policy
resource "aws_s3_bucket_policy" "open_access" {
  bucket = aws_s3_bucket.Email-App-SMW.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "Public_access"
    Statement = [
      {
        Sid = "IPAllow"
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.Email-App-SMW.arn}/*"
      },
    ]
  })
  depends_on = [ aws_s3_bucket_public_access_block.Email-App-SMW ]
}

#output S3 dns name and public IP
output "bucket_name" {
     value = aws_s3_bucket.Email-App-SMW.website_endpoint
}
output "bucket_dns_name" {
     value = aws_s3_bucket.Email-App-SMW.bucket_domain_name
}

