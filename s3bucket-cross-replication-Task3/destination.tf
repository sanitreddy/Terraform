# ------------------------------------------------------------------------------
# S3 bucket to act as the replication target.
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "destination" {
  provider = aws.account2
  bucket   = var.destination_bucket
}

resource "aws_s3_bucket_versioning" "destination" {
  provider = aws.account2
  bucket   = aws_s3_bucket.destination.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ------------------------------------------------------------------------------
# The destination bucket needs a policy that allows the source account to
# replicate into it.
# ------------------------------------------------------------------------------
resource "aws_iam_policy" "destination_policy" {
  provider = aws.account2
  name     = "destination-bucket-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:Replicate*"
        Resource = "arn:aws:s3:::${aws_s3_bucket.destination.bucket}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "destination_bucket_policy" {
  provider = aws.account2
  bucket   = aws_s3_bucket.destination.bucket

   policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::654654530894:root"
        }
        Action = "s3:Replicate*"
        Resource = "arn:aws:s3:::${aws_s3_bucket.destination.bucket}/*"
      }
    ]
  })
}
