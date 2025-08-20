# Consider adding defaults values to these variables if applicable
variable "env" {
  type        = string
  description = "AWS environment name (e.g., dev, prod)"
}

variable "panther_account_id" {
  type        = string
  description = "AWS account ID for Panther"
}

variable "panther_region" {
  type        = string
  description = "AWS region for Panther"
}


variable "scanner_account_id" {
  type        = string
  description = "AWS account ID for Scanner"
}

variable "scanner_external_id" {
  type        = string
  description = "External ID for Scanner IAM role"
}

variable "scanner_region" {
  type        = string
  description = "AWS region for Scanner"
}

