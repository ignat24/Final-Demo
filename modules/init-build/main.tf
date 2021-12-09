# Null resource for start first build
resource "null_resource" "make_build" {
  provisioner "local-exec" {
    command = "make build"
    working_dir = var.working_dir
    environment = {
      TAG = var.image_version
      REPOSITORY_REGION = var.aws_region
      APP_NAME = var.app
      ENV = var.env
     }
  }
}