variable "bucket_configs" {
    type = list(object({
        bucket_id = string
        bucket_arn = string
        bucket_kms_arn = optional(string)
    }))
    description = "List of S3 bucket configurations"
}

variable "panther_role_name" {
    type = string
    description = "IAM role name for Panther"
}

variable "scanner_role_name" {
    type = string
    description = "IAM role name for Scanner"
}

variable "topic_arn" {
    type = string
    description = "SNS topic ARN for notifications"
}