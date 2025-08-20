output "scanner_role_name" {
  value = aws_iam_role.scanner_role.name
}

output "scanner_index_bucket_name" {
  value = aws_s3_bucket.scanner_index_files_bucket.bucket
}