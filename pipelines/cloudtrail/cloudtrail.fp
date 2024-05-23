pipeline "create_cloudtrail_with_logging" {
  title       = "Create CloudTrail with CloudWatch Logging"
  description = "Creates a CloudTrail trail with integrated CloudWatch logging and necessary IAM roles and policies."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "log_group_name" {
    type        = string
    description = "The name of the log group to create."
    default     = "log_group_name_26"
  }

  param "role_name" {
    type        = string
    description = "The name of the IAM role to create."
    default     = "role_26"
  }

  param "trail_name" {
    type        = string
    description = "The name of the CloudTrail trail."
    default     = "trail_26"
  }

  param "s3_bucket_name" {
    type        = string
    description = "The name of the S3 bucket to which CloudTrail logs will be delivered."
    default     = "s3-bucket-name-26"
  }

  param "log_group_arn" {
    type        = string
    description = "The ARN of the CloudWatch log group."
    default     = "arn:aws:logs:us-east-1:533793682495:log-group:log_group_name_26:*"
  }

  param "role_arn" {
    type        = string
    description = "The ARN of the IAM role."
    default     = "arn:aws:iam::533793682495:role/role_26"
  }

 param "policy_arn" {
    type        = string
    description = "The ARN of the IAM role."
    default     = "arn:aws:iam::533793682495:policy/role_26"
  }

  param "acl" {
    type        = string
    description = "The access control list (ACL) for the new bucket (e.g., private, public-read)."
    optional    = true
  }

  param "assume_role_policy_document" {
    type        = string
    description = "The trust relationship policy document that grants an entity permission to assume the role. A JSON policy that has been converted to a string."
    default = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    })
  }

  param "bucket_policy" {
    type        = string
    description = "The S3 bucket policy for CloudTrail."
    default = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "AWSCloudTrailAclCheck20150319",
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "s3:GetBucketAcl",
          "Resource": "arn:aws:s3:::s3-bucket-name-26"
        },
        {
          "Sid": "AWSCloudTrailWrite20150319",
          "Effect": "Allow",
          "Principal": {
            "Service": "cloudtrail.amazonaws.com"
          },
          "Action": "s3:PutObject",
          "Resource": "arn:aws:s3:::s3-bucket-name-26/AWSLogs/533793682495/*",
          "Condition": {
            "StringEquals": {
              "s3:x-amz-acl": "bucket-owner-full-control"
            }
          }
        }
      ]
    })
  }

  param "cloudtrail_policy_document" {
    type        = string
    description = "The policy document that grants permissions for CloudTrail to write to CloudWatch logs."
    default = jsonencode({

		"Version": "2012-10-17",
		"Statement": [
			{
				"Sid": "AWSCloudTrailCreateLogStream2014110",
				"Effect": "Allow",
				"Action": [
					"logs:CreateLogStream"
				],
				"Resource": [
					"arn:aws:logs:us-east-1:533793682495:log-group:aws-cloudtrail-logs-533793682495-b6555b99:log-stream:533793682495_CloudTrail_us-east-1*"
				]
			},
			{
				"Sid": "AWSCloudTrailPutLogEvents20141101",
				"Effect": "Allow",
				"Action": [
					"logs:PutLogEvents"
				],
				"Resource": [
					"arn:aws:logs:us-east-1:533793682495:log-group:aws-cloudtrail-logs-533793682495-b6555b99:log-stream:533793682495_CloudTrail_us-east-1*"
				]
			}
		]
    })
  }

  // step "container" "create_iam_role" {
  //   image = "public.ecr.aws/aws-cli/aws-cli"
  //   cmd = [
  //     "iam", "create-role",
  //     "--role-name", param.role_name,
  //     "--assume-role-policy-document", param.assume_role_policy_document,
  //   ]

  //   env = credential.aws[param.cred].env
  // }

//  step "container" "create_iam_policy" {
//     // depends_on = [step.container.create_iam_role]
//     image = "public.ecr.aws/aws-cli/aws-cli"
//     cmd = [
//       "iam", "create-policy",
//       "--policy-name", param.role_name,
//       "--policy-document", param.cloudtrail_policy_document
//     ]

//     env = credential.aws[param.cred].env
//   }

// 	  step "container" "attach_policy_to_role" {
//     depends_on = [step.container.create_iam_policy]
//     image = "public.ecr.aws/aws-cli/aws-cli"
//    	cmd = [
//       "iam", "attach-role-policy",
//       "--role-name", param.role_name,
//       "--policy-arn", param.policy_arn,
//     	]


//     env = credential.aws[param.cred].env
//   }

  // step "container" "create_log_group" {
  //   depends_on = [step.container.create_iam_role]
  //   image = "public.ecr.aws/aws-cli/aws-cli"
  //   cmd = concat(
  //     ["logs", "create-log-group"],
  //     ["--log-group-name", param.log_group_name],
  //     ["--region", param.region]
  //   )

  //   env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  // }

  // step "container" "create_s3_bucket" {
  //   depends_on = [step.container.create_log_group]
  //   image = "public.ecr.aws/aws-cli/aws-cli"
  //   cmd = concat(
  //     ["s3api", "create-bucket"],
  //     ["--bucket", param.s3_bucket_name],
  //     param.acl != null ? ["--acl", param.acl] : [],
  //     param.region != "us-east-1" ? ["--create-bucket-configuration", "LocationConstraint=" + param.region] : []
  //   )

  //   env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  // }

  // step "container" "set_bucket_policy" {
  //   // depends_on = [step.container.attach_policy_to_role]
  //   image = "public.ecr.aws/aws-cli/aws-cli"
  //   cmd = [
  //     "s3api", "put-bucket-policy",
  //     "--bucket", param.s3_bucket_name,
  //     "--policy", param.bucket_policy
  //   ]

  //   env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  // }

  step "container" "create_trail" {
    // depends_on = [step.container.attach_policy_to_role]
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = concat(
      ["cloudtrail", "create-trail"],
      ["--name", param.trail_name],
      ["--is-multi-region-trail"],
      ["--s3-bucket-name", param.s3_bucket_name],
      ["--include-global-service-events"],
      ["--enable-log-file-validation"],
      ["--cloud-watch-logs-log-group-arn", param.log_group_arn],
      ["--cloud-watch-logs-role-arn", param.role_arn],
      ["--region", param.region]
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
