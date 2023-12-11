# AWS Mod for Flowpipe

A collection of [Flowpipe](https://flowpipe.io) pipelines that can be used to:
- Create EC2 Instances
- List S3 Buckets
- Create VPCs and Subnets
- And more!

![image](https://github.com/turbot/flowpipe-mod-aws/blob/main/docs/images/aws_ec2_start_instances.png?raw=true)

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/aws/pipelines)**

## Getting started

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

Configure your credentials:

```sh
vi ~/.flowpipe/config/aws
```

Using a profile:

```hcl
credential "aws" "aws_profile" {
  profile = "my-profile"
}
```

Or an access key pair:

```hcl
credential "aws" "aws_profile" {
  access_key = "AKIA..."
  secret_key = "dP+C+J..."
}
```

Or an access key pair with a session token:

```hcl
credential "aws" "aws_profile" {
  access_key = "AKIA..."
  secret_key = "dP+C+J..."
  session_token = "AQoDX..."
}
```

You can also set your credentials using environment variables:

- `AWS_PROFILE`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_PROFILE`

### Configuration

Configure your default region:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

```
region = "us-east-1"
```

When running a pipeline, you can override this region with `--arg region=ap-south-1`.

### Usage

Run a pipeline:

```sh
flowpipe pipeline run describe_ec2_instances
```

Or you can start the Flowpipe server and run the pipeline using the server:

```sh
flowpipe server
flowpipe pipeline run describe_ec2_instances --host local
```

## Passing pipeline arguments

To pass values into pipeline [parameters](https://flowpipe.io/docs/using-flowpipe/pipeline-parameters), use the following syntax:

```sh
flowpipe pipeline run describe_ec2_instances --arg instance_id=i-1234567890abcdef0
```

Multiple pipeline args can be passed in with separate `--arg` flags.

For more information on passing arguments, please see [Pipeline Args](https://flowpipe.io/docs/using-flowpipe/arguments).

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/flowpipe-mod)) we would love you to join the community and start contributing.

- **[Join #flowpipe in our Slack community ](https://flowpipe.io/community/join)**

Please see the [contribution guidelines](https://github.com/turbot/flowpipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/flowpipe/blob/main/CODE_OF_CONDUCT.md).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [AWS Mod](https://github.com/turbot/flowpipe-mod-aws/labels/help%20wanted)

## License

This mod is licensed under the [Apache License 2.0](https://github.com/turbot/flowpipe-mod-aws/blob/main/LICENSE).

Flowpipe is licensed under the [AGPLv3](https://github.com/turbot/flowpipe/blob/main/LICENSE).
