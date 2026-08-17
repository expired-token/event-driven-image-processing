variable "aws_region" {
  type        = string
  description = "AWS region where the project is deployed"
  default     = "eu-north-1"
}

variable "project_name" {
  type        = string
  description = "prefix for all resources"
  default     = "img-processing"
}

variable "sns_test_email" {
  type        = string
  description = "Email where sns notification will be sent to"
  sensitive   = true
}