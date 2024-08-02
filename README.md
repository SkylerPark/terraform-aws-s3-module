# terraform-aws-s3-module

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Component

아래 도구를 이용하여 모듈작성을 하였습니다. 링크를 참고하여 OS 에 맞게 설치 합니다.

> **macos** : ./bin/install-macos.sh

- [pre-commit](https://pre-commit.com)
- [terraform](https://terraform.io)
- [tfenv](https://github.com/tfutils/tfenv)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [tfsec](https://github.com/tfsec/tfsec)
- [tflint](https://github.com/terraform-linters/tflint)

## Services

Terraform 모듈을 사용하여 아래 서비스를 관리 합니다.

- **AWS S3 (Simple Storage Service)**
  - bucket
  - logging
  - acl
  - lifecycle
  - version
  - policy
  - notification

## Usage

아래 예시를 활용하여 작성가능하며 examples 코드를 참고 부탁드립니다.

### S3 Bucket lifecycle

S3 Bucket 을 만들고 lifecycle 설정 예시 입니다.

```hcl
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
```

### S3 Bucket notification

S3 Bucket 을 만들고 notification(SQS) 설정 예시 입니다.

```hcl
module "queue" {
  source = "git::https://github.com/SkylerPark/terraform-aws-sqs-module.git//modules/queue/?ref=tags/1.0.0"
  name   = "parksm-test-queue"
}

module "notification" {
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
```
