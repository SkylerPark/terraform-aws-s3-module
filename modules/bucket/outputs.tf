output "id" {
  description = "S3 bucket 이름 혹은 ID."
  value       = aws_s3_bucket.this.id
}

output "arn" {
  description = "S3 bucket ARN."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "S3 bucket domain name."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "S3 bucket region-specific domain name."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "hosted_zone_id" {
  description = "버킷 region 에 해당하는 Route53 호스팅 영역 ID."
  value       = aws_s3_bucket.this.hosted_zone_id
}

output "region" {
  description = "버킷 AWS region."
  value       = aws_s3_bucket.this.region
}

output "policy" {
  description = "버킷에 설정된 policy."
  value       = try(aws_s3_bucket_policy.this[0].policy, "")
}

output "lifecycle_configuration_rules" {
  description = "버킷에 설정된 lifecycle rule."
  value       = try(aws_s3_bucket_lifecycle_configuration.this[0].rule, "")
}
