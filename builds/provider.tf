provider "aws" {
  region = local.region

  default_tags {
    tags = {
      "evtech:environment"        = "${local.environment}"
      "evtech:owner"              = "cloudops@example.com"
      "evtech:program"            = "cloudops"
      "evtech:provisioned-by"     = local.provisioned_by_tag
      "evtech:longterm"           = "forever"
      "evtech:commit-hash"        = "commit_hash"
      "evtech:vpc-module-version" = replace(local.vpc_module_version, "?", "")
      "evtech:test-build"         = true
    }
  }
}

terraform {
  required_providers {
    null = {}
    aws = {
      version = "~> 3.63.0"
    }
  }
}