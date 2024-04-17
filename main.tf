resource "aws_instance" "demo" {
  ami                     = "ami-007855ac798b5175e"
  instance_type           = "t2.micro"

  tags = {
    name = "My VM"
  }
}