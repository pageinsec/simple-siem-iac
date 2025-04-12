include {
    path = find_in_parent_folders()
}

# Add dependency info for any inputs that will come from other stacks
config_path = "path"
mock_outputs = {
    cloudtrail_bucket_arn   = "arn:aws:s3:::fake-bucket"
    cloudtrail_bucket_id    = "arn:aws:s3:::fake-bucket-name"
    cloudtrail_key = "arn:aws:kms:us-east-1:123456789123:key/fake-key"
}

# Map any inputs received
inputs = {
    cloudtrail_bucket_arn = dependency.cloudtrail_bucket_arn
    cloudtrail_bucket_id  = dependency.cloudtrail_bucket_id
    cloudtrail_key = dependency.cloudtrail_key
    scanner_external_key = "<EXTERNAL_KEY>" # Obtained from Scanner during setup
}