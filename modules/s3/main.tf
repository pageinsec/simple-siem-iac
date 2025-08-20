# Grants bucket access

# Panther Permissions
resource "aws_iam_role_policy" "panther_read_data_policy" {
    for_each = { for config in var.bucket_configs : config.bucket_id => config }
    name = "panther-read-data-${each.key}"
    role = var.panther_role_name
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:GetBucketLocation",
                    "s3:ListBucket",
                ]
                Resource = each.value.bucket_arn
            },
            {
                Effect = "Allow",
                Action = "s3:GetObject",
                Resource = "${each.value.bucket_arn}/*"
            },
        ]
    })
}

# Add KMS permissions if needed
resource "aws_iam_role_policy" "panther_kms_policy" {
    for_each = { 
        for config in var.bucket_configs : config.bucket_id => config 
        if config.kms_arn != null
        }
    
    name = "panther-kms-policy-${each.key}"
    role = var.panther_role_name
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "kms:Decrypt",
                    "kms:DescribeKey",
                ]
                Resource = each.value.kms_arn
            },
        ]
    })
}

# Scanner Permissions
resource "aws_iam_role_policy" "scanner_read_data_policy" {
    for_each = { for config in var.bucket_configs : config.bucket_id => config }
    name = "scanner-read-data-${each.key}"
    role = var.scanner_role_name
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:GetBucketEncryption",
                    "s3:GetBucketNocation",
                    "s3:ListBucket",
                ]
                Resource = each.value.bucket_arn
            },
            {
                Effect = "Allow",
                Action = [
                    "s3:GetObject",
                    "s3:GetObjectTagging"
                ]
                Resource = "${each.value.bucket_arn}/*"
            },
        ]
    })
}

resource "aws_iam_role_policy" "scanner_kms_policy" {
    for_each = { 
        for config in var.bucket_configs : config.bucket_id => config
        if config.kms_arn != null
        }
    name = "scanner-kms-policy-${each.key}"
    role = var.scanner_role_name
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "kms:Decrypt",
                    "kms:DescribeKey",
                ]
                Resource = each.value.kms_arn
            },
        ]
    })
}