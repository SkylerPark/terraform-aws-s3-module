locals {
  region = "ap-northeast-2"
}

module "queue" {
  source = "git::https://github.com/SkylerPark/terraform-aws-sqs-module.git//modules/queue/?ref=tags/1.0.0"
  name   = "parksm-test-queue"
}

module "backup" {
  source = "../../modules/bucket"
  name   = "parksm-notification"
  notification = {
    enabled = true
    sqs_notifications = {
      "queue" = {
        queue_arn     = module.queue.arn
        events        = ["s3:ObjectCreated:*"]
        filter_suffix = ".json.gz"
      }
    }
  }
}
