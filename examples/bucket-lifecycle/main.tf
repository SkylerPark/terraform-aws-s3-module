locals {
  region = "ap-northeast-2"
}

module "s3-bucket" {
  source = "../../modules/bucket"
  name   = "parksm-s3"
  lifecycle_configuration = {
    enabled = true
    rules = [
      {
        id      = "15일 경과 파일 삭제"
        enabled = true
        expiration = {
          days                         = 15
          expired_object_delete_marker = false
        }
        noncurrent_version_expiration = {
          noncurrent_days = 1
        }
      }
    ]
  }
}
