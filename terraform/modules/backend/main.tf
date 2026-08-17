/* --- S3 STORAGE --- */

# Creating S3 bucket for image storage
resource "aws_s3_bucket" "image_bucket" {
  bucket = "image-storage-oaws-867637277826" # TODO - should not be hardcoded

  tags = {
    Name = "${var.project_name}-bucket"
  }
}

# Enabling bucket versioning
resource "aws_s3_bucket_versioning" "image_bucket_versioning" {
  bucket = aws_s3_bucket.image_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enabling server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "image_bucket_encryption" {
  bucket = aws_s3_bucket.image_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


/* --- SNS NOTIFICATION --- */

# Creating SNS topic
resource "aws_sns_topic" "process_outcome_topic" {
  name = "${var.project_name}-outcome-topic-oaws-867637277826"
}

# Enabling topic subscription and defining notification destination
resource "aws_sns_topic_subscription" "user_notification" {
  topic_arn = aws_sns_topic.process_outcome_topic.arn
  protocol  = "email"
  endpoint  = var.sns_test_email
}


/* --- OUTPUTS --- */
output "image_bucket_id" {
  value = aws_s3_bucket.image_bucket.id
}

output "image_bucket_arn" {
  value = aws_s3_bucket.image_bucket.arn
}

output "topic_arn" {
  value = aws_sns_topic.process_outcome_topic.arn
}