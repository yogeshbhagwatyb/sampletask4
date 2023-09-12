provider "aws" {
  region  = "us-east-1" # Don't change the region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "object12"
    key    = "yogesh.bhagwat"
    region = "us-east-1"
  }
}
