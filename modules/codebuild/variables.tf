variable "aws_region" {
  
}

variable "app" {
  
}

variable "env" {
  
}

variable "ecr_repository_url" {
  description = "Url ECR repository"
  
}

variable "vpc_id" {
  description = "VPC id"
}

variable "cidr_blocks"{
  description = "Cidr block for codebuild security group "
  default = "0.0.0.0/0"
}

variable "buildspec_file" {
  description = "Name for buildspec file"
  default = "buildspec.yml"
}

variable "buildspec_path" {
  description = "path to buildspec file(dependence on stage)"
}

# IMPORTANT - DON'T PUSH TOKEN TO GITHUB===============
variable "github_token" {
  description = "GitHub token"
  default = ""
}
# =====================================================



variable "private_subnet_ids" {
  description = "Private subnet ids for create codebuild in private subnets"
  type = set(string)
}

variable "pattern_branch" {
  description = "default pattern for codebuild"
  default = "^refs/heads"
}

variable "branch_githook" {
  description = "Variable for pattern that show what branch codebuild will be wait"
  default = "main"
}

variable "git_event" {
  description = "Variable for codebuild webhook that show after what start build"
  default = "PUSH"
}

variable "repository_url" {
  description = "GitHub repository url"
  default = "https://github.com/ignat24/Final-Demo.git"
}