provider "aws" {
  region = "us-east-1"
  alias  = "verzinia"
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "tokyo"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13.0"
    }
  }
}
