terraform {
    source = "../../../modules//cluster"
}

include {
    path = find_in_parent_folders()
}

dependencies {
    paths = ["../network"]
}

dependency "network" {
    config_path = "../network"
    mock_outputs = {
        vpc_id = "vpc-000000000000"
        private_subnet_ids = ["subnet-00000000000", "subnet-111111111111"]
        public_subnet_ids = ["subnet- 22222222222", "subnet-333333333333"]
      
  }
}

dependency "ecr" {
    config_path = "../ecr"
    mock_outputs = {
      ecr_repository_url = "000000000000.dkr.ecr.eu-west-1.amazonaws.com/image"
      ecr_repository_url_page = "000000000000.dkr.ecr.eu-west-1.amazonaws.com/image"
  }
}

inputs = {
    vpc_id = dependency.network.outputs.vpc_id
    private_subnet_ids = dependency.network.outputs.private_subnet_ids
    public_subnet_ids = dependency.network.outputs.public_subnet_ids
    ecr_repository_url = dependency.ecr.outputs.ecr_repository_url
    ecr_repository_url_page = dependency.ecr.outputs.ecr_repository_url_page
}

