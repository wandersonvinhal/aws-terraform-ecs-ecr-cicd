terraform {
  required_version = "~>1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "__S3_BUCKET__"
    key    = "__S3_KEY__"
    region = "__S3_REGION__"
    #dynamodb_table = "__DYNAMO_DB__"
  }
}

locals {
  az_names = __VPC_AZ_NAMES__
}
