# AWS Mod for Flowpipe

AWS pipeline library for [Flowpipe](https://flowpipe.io), enabling seamless integration of AWS services into your workflows.

<img src="https://github.com/turbot/flowpipe-mod-aws/blob/main/docs/images/aws_ec2_start_instances.png?raw=true" width="50%">

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/aws/pipelines)**

## Getting Started

### Requirements

Docker daemon must be installed and running. Please see [Install Docker engine](https://docs.docker.com/engine/install/) for more information.

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install flowpipe
```

Clone:

```sh
git clone https://github.com/turbot/flowpipe-mod-aws.git
cd flowpipe-mod-aws
```

### Credentials

By default, the following environment variables will be used to authenticate:

- `AWS_PROFILE`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_PROFILE`

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
  access_key = "AKIA..."
  secret_key = "dP+C+J..."
  session_token = "AQoDX..."
}
```

### Configuration

If you want to configure your default region and not need to enter it each pipeline run, you can set the `region` variable:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```hcl
region = "us-east-1"
```

When running a pipeline, you can override this default region with the `region` pipeline argument, e.g., `--arg region=ap-south-1`.

### Usage

List pipelines:

```sh
flowpipe pipeline list
```

Run a pipeline:

```sh
flowpipe pipeline run describe_ec2_instances
```

You can pass in pipeline arguments as well:

```sh
flowpipe pipeline run describe_ec2_instances --arg 'instance_ids=["i-1234567890abcdef0", "i-abcdef12345"]' --arg instance_type=t2.micro
```

To use a specific `credential`, specify the `cred` pipeline argument:

```sh
flowpipe pipeline run describe_ec2_instances --arg cred=aws_profile --arg instance_type=t2.micro
```

For more examples on how you can run pipelines, please see [Run Pipelines](https://flowpipe.io/docs/run/pipelines).

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](LICENSE). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but they cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

- **[Join #flowpipe in our Slack community ](https://flowpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [AWS Mod](https://github.com/turbot/flowpipe-mod-aws/labels/help%20wanted)
