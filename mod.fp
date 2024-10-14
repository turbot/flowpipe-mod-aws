mod "aws" {
  title         = "AWS"
  description   = "Run pipelines to supercharge your AWS workflows using Flowpipe."
  color         = "#FF9900"
  documentation = file("./README.md")
  icon          = "/images/mods/turbot/aws.svg"
  categories    = ["library", "public cloud"]

  opengraph {
    title       = "AWS Mod for Flowpipe"
    description = "Run pipelines to supercharge your AWS workflows using Flowpipe."
    image       = "/images/mods/turbot/aws-social-graphic.png"
  }

  require {
    flowpipe {
      min_version = "1.0.0"
    }
  }
}
