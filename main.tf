# Main code to deploy SIEM infrastructure using Terraform
# Create IAM resources
module "panther_iam" {
  source             = "./modules/iam/panther"
  env                = var.env
  panther_account_id = var.panther_account_id
}

module "scanner_iam" {
  source              = "./modules/iam/scanner"
  scanner_account_id  = var.scanner_account_id
  scanner_external_id = var.scanner_external_id
}

# Grant bucket access
module "s3_bucket_access" {
  source            = "./modules/s3/"
  panther_role_name = module.panther_iam.role_name
  scanner_role_name = module.scanner_iam.role_name
  topic_arn         = module.sns.siem_notification_topic_arn
  bucket_configs = [
    {
      # Replace with actual bucket details or use a variable referencing other IaC modules
      bucket_arn     = "arn:aws:s3:::example-bucket"
      bucket_id      = "example-bucket"
      bucket_kms_arn = "arn:aws:kms:us-east-1:123456789012:key/example-key"
    }
  ]
}

# Create SNS and associated SQS subs
# Do this last/separately to avoid failures - need to add AWS account to Panther prior to deployment
module "sns" {
  depends_on         = [module.panther_iam, module.scanner_iam]
  source             = "./modules/sns"
  env                = var.env
  panther_account_id = var.panther_account_id
  panther_region     = var.panther_region
  scanner_account_id = var.scanner_account_id
  scanner_region     = var.scanner_region
}