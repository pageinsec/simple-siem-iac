# Source: https://docs.scanner.dev/scanner/indexing-your-logs-in-s3/linking-aws-accounts/infra-as-code/terraform
# Create scanner role
resource "aws_iam_role" "scanner_role" {
  name = "scnr-ScannerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.scanner_account_id
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.scanner_external_id
          }
        }
      }
    ]
  })
}

# Create Scanner role policy
resource "aws_iam_role_policy" "scanner_read_buckets_policy" {
  name = "scanner-read-buckets-policy"
  role = aws_iam_role.scanner_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:GetBucketTagging",
          "s3:ListAllMyBuckets",
        ]
        Resource = ["*"]
      }
    ]
  })

}


# Create Scanner index bucket
resource "aws_s3_bucket" "scanner_index_files_bucket" {
  bucket = "scanner-index-files-${var.scanner_external_id}"
  // NOTE: With this flag, Terraform will disallow the deletion of the entire
  // stack. Unfortunately Terraform does not yet provide a way to protect only
  // some resources while deleting the rest.
  // Carefully consider whether your want this configured in your environment.
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "scanner_index_files_bucket_public_access_block" {
  bucket = aws_s3_bucket.scanner_index_files_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "scanner_index_files_bucket_encryption_config" {
  bucket = aws_s3_bucket.scanner_index_files_bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "scanner_index_files_bucket_lifecycle_configuration" {
  bucket = aws_s3_bucket.scanner_index_files_bucket.id

  rule {
    id     = "ExpireTagging"
    status = "Enabled"
    filter {
      tag {
        key   = "Scnr-Lifecycle"
        value = "expire"
      }
    }
    expiration {
      days = 1
    }
  }

  rule {
    id     = "AbortIncompleteMultiPartUploads"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}

# Configure access to S3 index bucket
resource "aws_iam_role_policy" "scanner_index_policy" {
  name = "ScannerIndexBucketPolicy"
  role = aws_iam_role.scanner_role.name
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "s3:GetEncryptionConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:DeleteObject",
          "s3:DeleteObjectTagging",
          "s3:DeleteObjectVersion",
          "s3:DeleteObjectVersionTagging",
          "s3:GetObject",
          "s3:GetObjectTagging",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:PutObjectTagging",
        ],
        Resource = [
          aws_s3_bucket.scanner_index_files_bucket.arn,
          "${aws_s3_bucket.scanner_index_files_bucket.arn}/*"
        ]
      }
    ]
  })
}
  