variable "project_name" {
  type        = string
  description = "prefix for all resources"
}

variable "sns_test_email" {
  type        = string
  description = "Email where sns notification will be sent to"
  sensitive   = true
}