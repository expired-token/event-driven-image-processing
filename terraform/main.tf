module "backend" {
  source         = "./modules/backend"
  project_name   = var.project_name
  sns_test_email = var.sns_test_email
}

module "compute" {
  source             = "./modules/compute"
  project_name       = var.project_name
  storage_bucket_arn = module.backend.image_bucket_arn
  storage_bucket_id  = module.backend.image_bucket_id
  sns_topic_arn      = module.backend.topic_arn
}
