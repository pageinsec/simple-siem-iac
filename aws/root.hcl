# AWS terragrunt
# See documentation for setup info
# Locals - stuff that applies to all accounts

# Remote state
remote_state {
    backend = "s3"
    config = {
        bucket = "<BUCKET_NAME>"
    }
}

