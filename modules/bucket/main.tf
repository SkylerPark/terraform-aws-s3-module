resource "aws_s3_bucket" "this" {
  bucket = lower(var.name)

  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled

  tags = var.tags
}

resource "aws_s3_bucket_logging" "this" {
  count = var.logging.enabled ? 1 : 0

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging.target_bucket
  target_prefix = var.logging.target_prefix

  dynamic "target_object_key_format" {
    for_each = var.logging.target_object_key_format.enabled ? [true] : []

    content {
      dynamic "partitioned_prefix" {
        for_each = (target_object_key_format.value.type == "event_time"
        ? [true] : [])

        content {
          partition_date_source = "EventTime"
        }
      }

      dynamic "partitioned_prefix" {
        for_each = (target_object_key_format.value.type == "delivery_time"
        ? [true] : [])

        content {
          partition_date_source = "DeliveryTime"
        }
      }

      dynamic "simple_prefix" {
        for_each = (target_object_key_format.value.type == "simple_prefix"
        ? [true] : [])

        content {}
      }
    }
  }
}

data "aws_canonical_user_id" "this" {}

resource "aws_s3_bucket_acl" "this" {
  count = var.acl.enabled ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = var.expected_bucket_owner

  acl = var.acl.type == "null" ? null : var.acl.type

  dynamic "access_control_policy" {
    for_each = length(var.acl.grants) > 0 ? [true] : []

    content {
      dynamic "grant" {
        for_each = var.acl.grants

        content {
          permission = grant.value.permission

          grantee {
            type          = grant.value.type
            id            = try(grant.value.id, null)
            uri           = try(grant.value.uri, null)
            email_address = try(grant.value.email, null)
          }
        }
      }

      owner {
        id           = try(var.acl.owner.id, data.aws_canonical_user_id.this.id)
        display_name = try(var.acl.owner.display_name, null)
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.acl.enabled && var.acl.type == "public-read" ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.acl.public_block_acls_enabled
  block_public_policy     = var.acl.public_block_policy_enabeld
  ignore_public_acls      = var.acl.public_ignore_acls_enabled
  restrict_public_buckets = var.acl.public_restrict_buckets_enabled
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.lifecycle_configuration.enabled ? 1 : 0

  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "rule" {
    for_each = var.lifecycle_configuration.rules

    content {
      id     = try(rule.value.id, null)
      status = try(rule.value.enabled ? "Enabled" : "Disabled", tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)))

      dynamic "abort_incomplete_multipart_upload" {
        for_each = try([rule.value.abort_incomplete_multipart_upload_days], [])

        content {
          days_after_initiation = try(rule.value.abort_incomplete_multipart_upload_days, null)
        }
      }

      dynamic "expiration" {
        for_each = try(flatten([rule.value.expiration]), [])

        content {
          date                         = try(expiration.value.date, null)
          days                         = try(expiration.value.days, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      dynamic "transition" {
        for_each = try(flatten([rule.value.transition]), [])

        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = try(flatten([rule.value.noncurrent_version_expiration]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.days, noncurrent_version_expiration.value.noncurrent_days, null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = try(flatten([rule.value.noncurrent_version_transition]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.days, noncurrent_version_transition.value.noncurrent_days, null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []

        content {}
      }

      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]

        content {
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)
          prefix                   = try(filter.value.prefix, null)

          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]

        content {
          and {
            object_size_greater_than = try(filter.value.object_size_greater_than, null)
            object_size_less_than    = try(filter.value.object_size_less_than, null)
            prefix                   = try(filter.value.prefix, null)
            tags                     = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.policy_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = var.policy
}

resource "aws_s3_bucket_versioning" "this" {
  count                 = var.versioning.enabled ? 1 : 0
  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = var.expected_bucket_owner
  mfa                   = var.versioning.mfa

  versioning_configuration {
    status     = var.versioning.status ? "Enabled" : "Suspended"
    mfa_delete = var.versioning.mfa_delete ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_notification" "this" {
  count       = var.notification.enabled ? 1 : 0
  bucket      = aws_s3_bucket.this.id
  eventbridge = var.notification.eventbridge

  dynamic "lambda_function" {
    for_each = var.notification.lambda_notifications

    content {
      id                  = try(lambda_function.value.id, lambda_function.key)
      lambda_function_arn = lambda_function.value.function_arn
      events              = lambda_function.value.events
      filter_prefix       = try(lambda_function.value.filter_prefix, null)
      filter_suffix       = try(lambda_function.value.filter_suffix, null)
    }
  }

  dynamic "queue" {
    for_each = var.notification.sqs_notifications

    content {
      id            = try(queue.value.id, queue.key)
      queue_arn     = queue.value.queue_arn
      events        = queue.value.events
      filter_prefix = try(queue.value.filter_prefix, null)
      filter_suffix = try(queue.value.filter_suffix, null)
    }
  }

  dynamic "topic" {
    for_each = var.notification.sns_notifications

    content {
      id            = try(topic.value.id, topic.key)
      topic_arn     = topic.value.topic_arn
      events        = topic.value.events
      filter_prefix = try(topic.value.filter_prefix, null)
      filter_suffix = try(topic.value.filter_suffix, null)
    }
  }
}
