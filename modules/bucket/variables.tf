variable "name" {
  description = "(필수) S3 bucket 이름."
  type        = string
  nullable    = false

  validation {
    condition = alltrue([
      length(var.name) >= 1,
      length(var.name) <= 63
    ])
    error_message = "Bucket 의 이름은 소문자 이며 길이가 63자 이하여야 합니다."
  }
}

variable "force_destroy" {
  description = "(선택) 버킷 삭제시 모든 객체를 삭제해야 오류없이 삭제 할수 있는 설정. Default: `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "object_lock_enabled" {
  description = "(선택) 버킷에 개체 잠금 구성 활성화 여부. Default: `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "expected_bucket_owner" {
  description = "(선택) 버킷에 소유자 계정ID"
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "(선택) 리소스 태그 내용"
  type        = map(string)
  default     = {}
}

variable "logging" {
  description = <<EOF
  (선택) S3 Bucket 에 대한 로깅 리소스 설정. `logging` 블록 내용.
    (선택) `enabled` - Bucket 에 로깅을 설정할지에 대한 여부. Default: `false`.
    (선택) `target_bucket` - 로깅시 저장할 Target Bucket 이름.
    (선택) `target_prefix` - 로깅시 저장할 Target Bucket Prefix.
    (선택) `target_object_key_format` - 로그 객체에 대한 설정 `target_object_key_format` 블록 내용.
      (선택) `enabled` - 로그 객체 설정 활성화 유무. Default: `false`.
      (선택) `type` - 로그 객체를 어떻게 분할할지에 대한 설정 다음 값을 지원 `event_time`, `delivery_time`, `simple_prefix`.
  EOF

  type = object({
    enabled       = optional(bool, false)
    target_bucket = optional(string, null)
    target_prefix = optional(string, null)
    target_object_key_format = optional(object({
      enabled = optional(bool, false)
      type    = optional(string, null)
    }), {})
  })
  nullable = false
  default  = {}

  validation {
    condition = alltrue([
      var.logging.target_object_key_format.enabled ? contains(["event_time", "delivery_time", "simple_prefix"], var.logging.target_object_key_format.type) : true
    ])
    error_message = "target_object_key_format 에 type 은 `event_time`, `delivery_time`, `simple_prefix` 하나만 선택 해야 합니다."
  }
}

variable "acl" {
  description = <<EOF
  (선택) S3 Bucket 에 대한 ACL 리소스 설정. `acl` 블록 내용.
    (선택) `enabled` - Bucket ACL 리소스를 설정할지에 대한 유무. Default: `false`.
    (선택) `type` - ACL 타입. 다음 값을 지원 `public-read`, `private` Default: `null`.
    (선택) `grants` - ACL 정책 부여. `type` 이 `null` 일 경우 설정.
    (선택) `owner` - 버킷 소유자 이름 및 ID. `type` 이 `null` 일 경우 설정.
    (선택) `public_block_acls_enabled`- `type` 이 `public-read` 일 경우 설정. S3가 이 버킷에 대한 퍼블릭 ACL을 차단해야 하는지 여부. Default: `false`.
    (선택) `public_block_policy_enabeld`- `type` 이 `public-read` 일 경우 설정. S3가 이 버킷에 대한 퍼블릭 정책을 차단해야 하는지 여부. Default: `false`.
    (선택) `public_ignore_acls_enabled`- `type` 이 `public-read` 일 경우 설정. S3가 이 버킷에 대한 퍼블릭 ACL을 무시해야 하는지 여부. Default: `false`.
    (선택) `public_restrict_buckets_enabled`- `type` 이 `public-read` 일 경우 설정. S3에서 이 버킷에 대한 퍼블릭 버킷 정책을 제한해야 하는지 여부. Default: `false`.
  EOF

  type = object({
    enabled = optional(bool, false)
    type    = optional(string, "null")
    grants  = optional(any, [])
    owner = optional(object({
      id           = optional(string, null)
      display_name = optional(string, null)
    }), {})
    public_block_acls_enabled       = optional(bool, false)
    public_block_policy_enabeld     = optional(bool, false)
    public_ignore_acls_enabled      = optional(bool, false)
    public_restrict_buckets_enabled = optional(bool, false)
  })
  nullable = false
  default  = {}

  validation {
    condition = alltrue([
      var.acl.enabled ? var.acl.type != null ? contains(["public-read", "private"], var.acl.type) : true : true
    ])
    error_message = "acl 에 type 은 `public-read`, `private`, `null` 중 하나만 선택 해야 합니다."
  }
}

variable "lifecycle_configuration" {
  description = <<EOF
  (선택) S3 Bucket 에 lifecycle 리소스 설정. `lifecycle_configuration` 블록 내용.
    (선택) `enabled` - Bucket lifecycle 리소스를 설정할지에 대한 유무. Default: `false`.
    (선택) `rules` - 버킷 객체 수명주기 관리 구성 리스트.
  EOF

  type = object({
    enabled = optional(bool, false)
    rules   = optional(any, [])
  })
  nullable = false
  default  = {}
}

variable "policy_enabled" {
  description = "(선택) S3 버킷 policy 리소스 생성 유무. Default: `false`"
  type        = bool
  default     = false
  nullable    = false
}

variable "policy" {
  description = "(선택) JSON 형식의 정책 문서."
  type        = string
  default     = null
  nullable    = true
}

variable "versioning" {
  description = <<EOF
  (선택) S3 Bucket Version 리소스 설정. `versioning` 블록 내용.
    (선택) `enabled` - Bucket versioning 리소스를 설정할지에 대한 유무. Default: `false`.
    (선택) `mfa` - `status` 와 `mfa_delete` 가 `true` 일경우 필수이며, 인증장치에 일련번호.
    (필수) `status` - 버킷의 버전 관리 상태. Default: `true`.
    (선택) `mfa_delete` - 버킷 버전 관리 구성에서 MFA 삭제가 활성화되어 있는지 여부. Default: `false`.
  EOF

  type = object({
    enabled    = optional(bool, false)
    mfa        = optional(string, null)
    status     = optional(bool, true)
    mfa_delete = optional(bool, true)
  })
  nullable = false
  default  = {}
}

variable "notification" {
  description = <<EOF
  (선택) S3 Bucket 알림 구성. `notification` 블록 내용.
    (선택) `enabled` - S3 Bucket 알림 구성 활성화 유무. Default: `false`.
    (선택) `eventbridge` - EventBridge 알림을 활성화할지 여부. Default: `false`.
    (선택) `lambda_notifications` - Lambda 함수를 이용한 알림 구성.
    (선택) `sqs_notifications` - SQS Queue 를 이용한 알림 구성.
    (선택) `sns_notifications` - SNS 주제에 대한 알림 구성.
  EOF
  type = object({
    enabled              = optional(bool, false)
    eventbridge          = optional(bool, false)
    lambda_notifications = optional(any, {})
    sqs_notifications    = optional(any, {})
    sns_notifications    = optional(any, {})
  })
  nullable = false
  default  = {}
}
