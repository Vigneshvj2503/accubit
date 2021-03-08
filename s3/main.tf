provider "aws" {
  region = var.region
  version = "~> 2.64.0"

  assume_role {
    role_arn    = var.assume_role_arn
    external_id = var.external_id
  }
}


# S3 bucket creation
resource "aws_s3_bucket" "bucket" {
    bucket  = "${var.env}-s3-${var.bucketname}-bucket"
    acl     = "private"

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
      rule {
          apply_server_side_encryption_by_default {
          kms_master_key_id = "arn:"
          sse_algorithm     = "aws:kms"
        }
      }
    }
  tags = {
    Name  = "${var.env}-${var.bucketname}-bucket"
  }

}

resource "aws_s3_bucket_public_access_block" "S3ACLS" {
  bucket = "${aws_s3_bucket.bucket.id}"

  block_public_acls   = true
  block_public_policy = true
}
