variable aws_region {
  default = "ap-southeast-1"
}

terraform {
  # LOCAL STATE ONLY
  required_version = ">= 0.11.0"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "~> 1.12"
}

provider "vault" {
  version = "~> 1.0"
}

variable project {
  default = "devops-sg-demo"
}

locals {
  dns = "${terraform.workspace == "production" ? var.project : format("%s-%s",var.project,terraform.workspace)}.honestbee.com"

  secrets = "${jsonencode(map("HOST", local.dns,
                  "SECRET_HASH", module.secret.hash,
                  "SECRET2_HASH", module.secret2.hash,
                  "SECRET3_HASH", module.secret2.hash,
                  "AWS_REGION", var.aws_region,
                  "AWS_S3_BUCKET", module.s3bucket.id,
  ))}"

  secret_path = "secret/${terraform.workspace}/${var.project}"
}

module "secret" {
  source = "https://tf-modules.internal.honestbee.com/modules/random-password-1.3.3.tar.gz"
}

module "secret2" {
  source = "https://tf-modules.internal.honestbee.com/modules/random-password-1.3.3.tar.gz"
}

module "secret3" {
  source = "https://tf-modules.internal.honestbee.com/modules/random-password-1.3.3.tar.gz"
}

module "s3bucket" {
  source        = "https://tf-modules.internal.honestbee.com/modules/aws-bucket-1.3.3.tar.gz"
  namespace     = "honestbee"
  stage         = "${terraform.workspace}"
  name          = "${var.project}"
  access        = "private"
  force_destroy = true
  region        = "ap-southeast-1"
}

module "weighted_routes" {
  source = "https://tf-modules.internal.honestbee.com/modules/aws-static-weighted-routes-1.3.3.tar.gz"

  record = "${local.dns}"
  ttl    = 120

  origin_map = {
    origin1 = "apse1a-${local.dns}"
    origin2 = "apse1b-${local.dns}"
  }

  weight_map = {
    origin1 = 50
    origin2 = 50
  }

  health_check_name = "${var.project}"
  stage             = "${terraform.workspace}"
}

resource "vault_generic_secret" "secrets" {
  path = "${local.secret_path}"

  data_json = "${local.secrets}"
}
