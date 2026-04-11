terraform {
  backend "s3" {
    bucket         = "taskapp-terraform-state-448866496656"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "taskapp-terraform-locks"
    encrypt        = true
  }
}
