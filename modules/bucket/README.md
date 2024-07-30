# bucket

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.10 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_canonical_user_id.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | (선택) S3 Bucket 에 대한 ACL 리소스 설정. `acl` 블록 내용.<br>    (선택) `enabled` - Bucket ACL 리소스를 설정할지에 대한 유무. Default: `false`.<br>    (선택) `type` - ACL 타입. 다음 값을 지원 `public-read`, `private` Default: `null`.<br>    (선택) `grants` - ACL 정책 부여. `type` 이 `null` 일 경우 설정.<br>    (선택) `owner` - 버킷 소유자 이름 및 ID. `type` 이 `null` 일 경우 설정.<br>    (선택) `public_block_acls_enabled`- `type` 이 `public-read` 일 경우 설정. S3가 이 버킷에 대한 퍼블릭 ACL을 차단해야 하는지 여부. Default: `false`.<br>    (선택) `public_block_policy_enabeld`- `type` 이 `public-read` 일 경우 설정. S3가 이 버킷에 대한 퍼블릭 정책을 차단해야 하는지 여부. Default: `false`.<br>    (선택) `public_ignore_acls_enabled`- `type` 이 `public-read` 일 경우 설정. S3가 이 버킷에 대한 퍼블릭 ACL을 무시해야 하는지 여부. Default: `false`.<br>    (선택) `public_restrict_buckets_enabled`- `type` 이 `public-read` 일 경우 설정. S3에서 이 버킷에 대한 퍼블릭 버킷 정책을 제한해야 하는지 여부. Default: `false`. | <pre>object({<br>    enabled = optional(bool, false)<br>    type    = optional(string, "null")<br>    grants  = optional(any, [])<br>    owner = optional(object({<br>      id           = optional(string, null)<br>      display_name = optional(string, null)<br>    }), {})<br>    public_block_acls_enabled       = optional(bool, false)<br>    public_block_policy_enabeld     = optional(bool, false)<br>    public_ignore_acls_enabled      = optional(bool, false)<br>    public_restrict_buckets_enabled = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_expected_bucket_owner"></a> [expected\_bucket\_owner](#input\_expected\_bucket\_owner) | (선택) 버킷에 소유자 계정ID | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | (선택) 버킷 삭제시 모든 객체를 삭제해야 오류없이 삭제 할수 있는 설정. Default: `false`. | `bool` | `false` | no |
| <a name="input_lifecycle_configuration"></a> [lifecycle\_configuration](#input\_lifecycle\_configuration) | (선택) S3 Bucket 에 lifecycle 리소스 설정. `lifecycle_configuration` 블록 내용.<br>    (선택) `enabled` - Bucket lifecycle 리소스를 설정할지에 대한 유무. Default: `false`.<br>    (선택) `rules` - 버킷 객체 수명주기 관리 구성 리스트. | <pre>object({<br>    enabled = optional(bool, false)<br>    rules   = optional(any, [])<br>  })</pre> | `{}` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | (선택) S3 Bucket 에 대한 로깅 리소스 설정. `logging` 블록 내용.<br>    (선택) `enabled` - Bucket 에 로깅을 설정할지에 대한 여부. Default: `false`.<br>    (선택) `target_bucket` - 로깅시 저장할 Target Bucket 이름.<br>    (선택) `target_prefix` - 로깅시 저장할 Target Bucket Prefix.<br>    (선택) `target_object_key_format` - 로그 객체에 대한 설정 `target_object_key_format` 블록 내용.<br>      (선택) `enabled` - 로그 객체 설정 활성화 유무. Default: `false`.<br>      (선택) `type` - 로그 객체를 어떻게 분할할지에 대한 설정 다음 값을 지원 `event_time`, `delivery_time`, `simple_prefix`. | <pre>object({<br>    enabled       = optional(bool, false)<br>    target_bucket = optional(string, null)<br>    target_prefix = optional(string, null)<br>    target_object_key_format = optional(object({<br>      enabled = optional(bool, false)<br>      type    = optional(string, null)<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (필수) S3 bucket 이름. | `string` | n/a | yes |
| <a name="input_notification"></a> [notification](#input\_notification) | (선택) S3 Bucket 알림 구성. `notification` 블록 내용.<br>    (선택) `enabled` - S3 Bucket 알림 구성 활성화 유무. Default: `false`.<br>    (선택) `eventbridge` - EventBridge 알림을 활성화할지 여부. Default: `false`.<br>    (선택) `lambda_notifications` - Lambda 함수를 이용한 알림 구성.<br>    (선택) `sqs_notifications` - SQS Queue 를 이용한 알림 구성.<br>    (선택) `sns_notifications` - SNS 주제에 대한 알림 구성. | <pre>object({<br>    enabled              = optional(bool, false)<br>    eventbridge          = optional(bool, false)<br>    lambda_notifications = optional(any, {})<br>    sqs_notifications    = optional(any, {})<br>    sns_notifications    = optional(any, {})<br>  })</pre> | `{}` | no |
| <a name="input_object_lock_enabled"></a> [object\_lock\_enabled](#input\_object\_lock\_enabled) | (선택) 버킷에 개체 잠금 구성 활성화 여부. Default: `false`. | `bool` | `false` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | (선택) JSON 형식의 정책 문서. | `string` | `null` | no |
| <a name="input_policy_enabled"></a> [policy\_enabled](#input\_policy\_enabled) | (선택) S3 버킷 policy 리소스 생성 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (선택) 리소스 태그 내용 | `map(string)` | `{}` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | (선택) S3 Bucket Version 리소스 설정. `versioning` 블록 내용.<br>    (선택) `enabled` - Bucket versioning 리소스를 설정할지에 대한 유무. Default: `false`.<br>    (선택) `mfa` - `status` 와 `mfa_delete` 가 `true` 일경우 필수이며, 인증장치에 일련번호.<br>    (필수) `status` - 버킷의 버전 관리 상태. Default: `true`.<br>    (선택) `mfa_delete` - 버킷 버전 관리 구성에서 MFA 삭제가 활성화되어 있는지 여부. Default: `false`. | <pre>object({<br>    enabled    = optional(bool, false)<br>    mfa        = optional(string, null)<br>    status     = optional(bool, true)<br>    mfa_delete = optional(bool, true)<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | S3 bucket ARN. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | S3 bucket domain name. |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | S3 bucket region-specific domain name. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | 버킷 region 에 해당하는 Route53 호스팅 영역 ID. |
| <a name="output_id"></a> [id](#output\_id) | S3 bucket 이름 혹은 ID. |
| <a name="output_lifecycle_configuration_rules"></a> [lifecycle\_configuration\_rules](#output\_lifecycle\_configuration\_rules) | 버킷에 설정된 lifecycle rule. |
| <a name="output_policy"></a> [policy](#output\_policy) | 버킷에 설정된 policy. |
| <a name="output_region"></a> [region](#output\_region) | 버킷 AWS region. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
