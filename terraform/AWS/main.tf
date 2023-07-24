terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4.0"
    }
  }
  backend "s3" {
    bucket = "mlflow-terraform-test-state"
    key    = "test/terraform.tfstate"
    region = "eu-central-1"
  }
  required_version = ">= 1.5"
}

provider "aws" {
  region = var.region

  default_tags {
    tags = local.tags
  }
}