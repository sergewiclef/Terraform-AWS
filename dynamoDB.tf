//Creation of the DynamoDB that will host retrieved data from Twitter
resource "aws_dynamodb_table" "twitter_dynamoDB" {
name="twitter_dynamoDB"
hash_key       = "UserHandle"
range_key      = "TimeStamp"
read_capacity  = 20
write_capacity = 20


attribute {
    name = "UserHandle"
    type = "S"
  }

  attribute {
    name = "TimeStamp"
    type = "S"
  }
}