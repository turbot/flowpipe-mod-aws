# AWS Mod for Flowpipe

AWS pipeline library for [Flowpipe](https://flowpipe.io), enabling seamless integration of AWS services into your workflows.

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/aws/pipelines)**

## Getting Started

### Requirements

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

### Credentials

By default, the following environment variables will be used for authentication:

- `AWS_PROFILE`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

You can also create `credential` resources in configuration files:

```sh
vi ~/.flowpipe/config/aws.fpc
```

```hcl
credential "aws" "aws_profile" {
  profile = "my-profile"
}

credential "aws" "aws_access_key_pair" {
  access_key = "AKIA..."
  secret_key = "dP+C+J..."
}

credential "aws" "aws_session_token" {
  access_key    = "AKIA..."
  secret_key    = "dP+C+J..."
  session_token = "AQoDX..."
}
```

For more information on credentials in Flowpipe, please see [Managing Credentials](https://flowpipe.io/docs/run/credentials).

### Usage

[Initialize a mod](https://www.flowpipe.io/docs/mods/index#initializing-a-mod):

```sh
mkdir my_mod
cd my_mod
flowpipe mod init
```

[Install the AWS mod](https://www.flowpipe.io/docs/mods/mod-dependencies#mod-dependencies) as a dependency:

```sh
flowpipe mod install github.com/turbot/flowpipe-mod-aws
```

[Use the dependency](https://www.flowpipe.io/docs/mods/write-pipelines/index) in a pipeline step:

```sh
vi my_pipeline.fp
```

```hcl
pipeline "my_pipeline" {

  step "pipeline" "describe_ec2_instances" {
    pipeline = aws.pipeline.describe_ec2_instances
    args = {
      instance_type = "t2.micro"
      region        = "us-east-1"
    }
  }
}
```

[Run the pipeline](https://www.flowpipe.io/docs/run/pipelines):

```sh
flowpipe pipeline run my_pipeline
```

### Developing

Clone:

```sh
git clone https://github.com/turbot/flowpipe-mod-aws.git
cd flowpipe-mod-aws
```

List pipelines:

```sh
flowpipe pipeline list
```

Run a pipeline:

```sh
flowpipe pipeline run describe_ec2_instances --arg 'instance_ids=["i-1234567890abcdef0", "i-abcdef12345"]' --arg instance_type=t2.micro --arg region=ap-south-1
```

To use a specific `credential`, specify the `cred` pipeline argument:

```sh
flowpipe pipeline run describe_ec2_instances --arg cred=aws_profile --arg instance_type=t2.micro --arg region=us-east-1
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [AWS Mod](https://github.com/turbot/flowpipe-mod-aws/labels/help%20wanted)
