# Simple SIEM Infrastructure

This repository provides Terraform configurations for deploying SIEM (Security Information and Event Management) infrastructure in AWS with minimal resource sprawl. It's designed for enterprises with established Infrastructure as Code (IaC) practices. It is recommended to use this in conjunction with existing CI/CD pipelines such as GitHub Actions. Adjust the code as necessary to fit your environment.

## Overview

SIEM vendors often provide Terraform code that creates unnecessary duplicate resources or doesn't scale well in enterprise environments. This implementation focuses on:

* Single IAM role per SIEM vendor per AWS account
* Single SNS topic per AWS account
* Per-bucket policies for each vendor
* KMS policies as needed
* SNS notifications to SQS queues for each vendor

## Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.0.0
- AWS CLI configured with appropriate credentials and/or
- GitHub Action configured to deploy resources to AWS
- S3 bucket for Terraform state
- Access to target AWS accounts
- SIEM vendor accounts (Panther, Scanner)

## Repository Structure

```
.
├── modules/
│   ├── iam/
│   │   ├── panther/        # Panther-specific IAM configurations
│   │   └── scanner/        # Scanner-specific IAM configurations
│   ├── s3/                 # S3 bucket access configurations
│   └── sns/                # SNS/SQS notification configurations
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
└── providers.tf            # Provider configurations
```

## Setup Instructions (quick)
1. Clone this repository:
```bash
git clone https://github.com/yourusername/simple-siem-iac.git
cd simple-siem-iac
```
2. Pull the modules over to where AWS infrastructure is deployed.
3. Use the `main.tf` file as your module to deploy resources. Update the information as needed.

_Be sure to address the providers.tf file to update the backend and any tagging needs_


## Setup Instructions (full)

1. Clone this repository:
```bash
git clone https://github.com/yourusername/simple-siem-iac.git
cd simple-siem-iac
```

2. Create a `terraform.tfvars` file:
```hcl
env                = "dev"
panther_account_id = "123456789012"
panther_region     = "us-east-1"
scanner_account_id = "210987654321"
scanner_region     = "us-east-1"
scanner_external_id = "your-external-id"
```

3. Update the backend configuration in `providers.tf`:
```hcl
backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "siem/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
}
```

4. Initialize Terraform:
```bash
terraform init
```

5. Plan and apply the changes:
```bash
terraform plan -out=tfplan
terraform apply tfplan
```

## Module Configuration

### IAM Module
Configures IAM roles for SIEM vendors:
```hcl
module "panther_iam" {
  source             = "./modules/iam/panther"
  env                = "dev"
  panther_account_id = "123456789012"
}
```

### S3 Access Module
Configures bucket access for vendors:
```hcl
module "s3_bucket_access" {
  source            = "./modules/s3/"
  bucket_configs = [
    {
      bucket_arn     = "arn:aws:s3:::your-bucket"
      bucket_id      = "your-bucket"
      bucket_kms_arn = "arn:aws:kms:region:account:key/key-id"  # Optional
    }
  ]
}
```

### SNS Module
Sets up notifications:
```hcl
module "sns" {
  source             = "./modules/sns"
  env                = "dev"
  panther_account_id = "123456789012"
  panther_region     = "us-east-1"
}
```

## Important Notes

1. **Order of Operations**: 
   - Deploy IAM roles first
   - Set up vendor accounts
   - Deploy SNS/SQS configurations last

2. **Security Considerations**:
   - Use KMS encryption for sensitive buckets
   - Follow least privilege principle for IAM roles
   - Enable AWS CloudTrail for audit logging

3. **Maintenance**:
   - Regularly update provider versions
   - Monitor IAM role usage
   - Review bucket policies periodically

## Vendor Integration

### Panther
1. Create Panther account
2. Deploy IAM role
3. Add AWS account to Panther console
4. Deploy SNS/SQS configurations

### Scanner
1. Obtain Scanner external ID
2. Deploy IAM role
3. Configure Scanner with role ARN
4. Deploy SNS/SQS configurations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Create a pull request

## License

MIT Licence

## Support

No support is promised or provided.