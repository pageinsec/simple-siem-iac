# Source https://docs.panther.com/panther-developer-workflows/terraform/s3
# Create panther role
resource "aws_iam_role" "panther_role" {
  name = "PantherLogProcessingRole-${var.env}"

  # Policy that grants an entity permission to assume the role
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${var.panther_account_id}:root"
        }
        Condition : {
          Bool : { "aws:SecureTransport" : true }
        }
      }
    ]
  })
}