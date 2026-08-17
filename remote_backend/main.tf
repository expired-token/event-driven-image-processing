resource "aws_s3_bucket" "state_bucket" {
  bucket = "remote-state-management-oaws-867637277826"

  tags = {
    Name = "Remote State Storage Bucket"
  }
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "state_bucket_policy" {
  bucket = aws_s3_bucket.state_bucket.id
  policy = data.aws_iam_policy_document.allow_limited_access_to_state_bucket.json
}

data "aws_iam_policy_document" "allow_limited_access_to_state_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::867637277826:role/GitHubActionsTerraformRole"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.state_bucket.arn,
      "${aws_s3_bucket.state_bucket.arn}/*",
    ]
  }
}