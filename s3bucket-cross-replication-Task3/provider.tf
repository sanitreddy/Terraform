provider "aws" {
  alias   = "account1"
  region  = "ap-south-1"
}

provider "aws" {
  alias   = "account2"
  region  = "ap-south-1"
  assume_role {
    role_arn = "arn:aws:iam::211125474755:role/AdminTerraformRole"
  }
}