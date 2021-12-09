locals {
    app = "telebot"
    env = "dev"
    aws_profile = "default"
    aws_account = "873827770697"
    az_count = 2
    aws_region = "eu-central-1"
    image_version = "0.1"
    branch_githook = "EC2"
    buildspec_path = "providers/dev"

}

inputs = {
    app = local.app
    env = local.env
    aws_profile = local.aws_profile
    aws_account = local.aws_account
    aws_region = local.aws_region
    image_version = local.image_version
    az_count = local.az_count
    branch_githook = local.branch_githook
    buildspec_path = local.buildspec_path
}

remote_state {
    backend = "s3" 

    config = {
        encrypt = true
        bucket = "s3-${local.app}-${local.env}"
        key =  format("%s/terraform.tfstate", path_relative_to_include())
        region = local.aws_region
  }
}
