variable "project_name" {
  type        = string
  description = "prefix for all resources"
}

variable "storage_bucket_id" {
  type        = string
  description = "ID of bucket storing uploaded images"
}

variable "storage_bucket_arn" {
  type        = string
  description = "ARN of bucket storing uploaded images"
}

variable "sns_topic_arn" {
  type        = string
  description = "ARN of notification topic upon finished image processing"
}