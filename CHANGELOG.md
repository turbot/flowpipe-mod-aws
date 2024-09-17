## v0.4.1 [2024-09-17]

_Bug fixes_

- Fixed `put_s3_bucket_encryption` pipeline to correctly encrypt an S3 bucket without returning an error. ([#68](https://github.com/turbot/flowpipe-mod-aws/pull/68)) (Thanks [@gcasilva](https://github.com/gcasilva) for the contribution!)

## v0.4.0 [2024-07-24]

_What's new?_

- Added 22 new pipelines for seamless integration with your CloudWatch, EC2, IAM, KMS, VPC resources, and more.

## v0.3.0 [2024-05-17]

_What's new?_

- Added the following new pipeline:
  - `delete_dynamodb_table`

## v0.2.0 [2024-05-13]

_What's new?_

- Added the following new pipelines:
  - `delete_ebs_volume`
  - `delete_eks_node_group`
  - `delete_elasticache_cluster`
  - `delete_elbv2_load_balancer`
  - `delete_nat_gateway`
  - `delete_rds_db_instance`
  - `delete_route53_health_check`
  - `delete_secretsmanager_secret`
  - `detach_ebs_volume`
  - `put_s3_bucket_lifecycle_policy`
  - `release_eip`
  - `terminate_emr_clusters`
  - `update_route53_record`

## v0.1.1 [2024-03-04]

_Bug fixes_

- Fixed type of`min_interval` arg in`retry` blocks in EC2 test pipelines.

## v0.1.0 [2023-12-13]

_What's new?_

- Added 75+ pipelines to make it easy to connect your EC2, IAM, S3, SNS, VPC resources and more. For usage information and a full list of pipelines, please see [AWS Mod for Flowpipe](https://hub.flowpipe.io/mods/turbot/aws).
