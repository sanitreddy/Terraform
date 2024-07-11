resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-csv-bucket-1230"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_s3_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "lambda_s3_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action = [
            "s3:GetObject",
            "s3:ListBucket"
          ],
          Effect = "Allow",
          Resource = [
            "${aws_s3_bucket.my_bucket.arn}",
            "${aws_s3_bucket.my_bucket.arn}/*"
          ]
        },
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          Effect = "Allow",
          Resource = "arn:aws:logs:*:*:*"
        }
      ]
    })
  }
}

resource "aws_lambda_function" "read_csv" {
  filename         = "lambda_function.zip"
  function_name    = "ReadCSVFromS3"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda_function.zip")
  runtime          = "python3.12"
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_csv.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.my_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.read_csv.arn
    events              = ["s3:ObjectCreated:*"]
  }
}