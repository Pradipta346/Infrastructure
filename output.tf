/*output "my-vpc-id" {
  value       = aws_vpc.my-vpc.id
  description = "The ID of the VPC"
}

output "public_subnet-ARN" {
  value = aws_subnet.public_subnet.arn
  description = "The ARN of the public subnet"
  }*/

output "user_arn" {
  value = aws_iam_user.s3_readonly_user.arn
}
