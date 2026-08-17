# Implementing Lambda role
resource "aws_iam_role" "lambda_role" {
  name = "LambdaForImageProcessing"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : { "Service" : "lambda.amazonaws.com" },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

# Declaring Lambda's inline IAM policies 
resource "aws_iam_role_policy" "lambda_iam_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = ["s3:GetObject"]
          Resource = "${var.storage_bucket_arn}/*"
        },
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
          ]
          Resource = "arn:aws:logs:*:*:*" # TODO - understand thie a bit more
        },
        {
          Effect   = "Allow"
          Action   = ["sns:Publish"]
          Resource = var.sns_topic_arn # TODO - make sure this works
        }
      ]
    }
  )
}

resource "aws_ecr_repository" "lambda_repository" {
  name = "${var.project_name}-lambda-repository"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Implementing Lambda function for image processing
resource "aws_lambda_function" "image_processing_function" {
  function_name = "${var.project_name}-function"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repository.repository_url}:latest"

  environment {
    variables = {
      TOPIC_ARN = var.sns_topic_arn
    }
  }
}

# Allowing S3 to Invoke Lambda
# N.B - This permission overwrites lambda's default resource-based policy, which rejects of all incoming requests from any service, enabling our specific S3 bucket to invoke the function upon S3 event trigger */
resource "aws_lambda_permission" "allow_bucket_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processing_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.storage_bucket_arn
}

# Connecting S3 Event to Lambda
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.storage_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processing_function.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket_to_invoke_lambda]
}

