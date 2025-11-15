resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-modules-bucket-1"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
