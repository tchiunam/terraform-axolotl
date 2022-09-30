resource "aws_s3_bucket" "terraform_state" {
  bucket = "axolotl-terraform-state"

  // Enable this when you want to delete the bucket
  // force_destroy = true
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Project     = "terraform"
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  depends_on = [aws_s3_bucket_versioning.terraform_state]

  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id = "terraform_state"

    filter {
      tag {
        key   = "Project"
        value = "terraform"
      }
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "axolotl-terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project     = "terraform"
    Environment = terraform.workspace
  }
}
