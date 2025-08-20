variable "env" {
  type        = string
  description = "AWS environment name (e.g., dev, prod)"
}

variable "panther_account_id" {
  type        = string
  description = "AWS account ID for Panther"
}