# ------------------------------------------------------------------------------
# S3 bucket to act as the replication source, i.e. the primary copy of the data
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "source" {
  provider = aws.account1
  bucket   = var.source_bucket
}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.account1
  bucket   = aws_s3_bucket.source.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.account1
  depends_on = [aws_s3_bucket_versioning.source]
  bucket   = aws_s3_bucket.source.id
  role = aws_iam_role.replication.arn

  rule {
    id     = "replicate-to-account2"
    status = "Enabled"

    filter {
      prefix = ""
    }

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
    delete_marker_replication {
        status = "Enabled"
      }
  }
}

# ------------------------------------------------------------------------------
# IAM role that S3 can use to read our bucket for replication
# ------------------------------------------------------------------------------
resource "aws_iam_role" "replication" {
  provider = aws.account1
  name = "replication"
  description = "Allow S3 to assume the role for replication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "replication" {
  provider = aws.account1
  role     = aws_iam_role.replication.id

   policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "arn:aws:s3:::${aws_s3_bucket.source.bucket}/*"
      },
      {
        Effect = "Allow"
        Action = "s3:ListBucket"
        Resource = "arn:aws:s3:::${aws_s3_bucket.source.bucket}"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = "arn:aws:s3:::${aws_s3_bucket.destination.bucket}/*"
      }
    ]
  })
}
