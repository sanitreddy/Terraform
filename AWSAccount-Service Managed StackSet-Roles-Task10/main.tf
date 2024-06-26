provider "aws" {
  region = "ap-south-1"
}

resource "aws_organizations_account" "new_account" {
  name  = "Sanit StackSet Account1"
  email = "sanitreddy+StackSet1@gmail.com"
}

resource "aws_cloudformation_stack_set" "iam_role_stackset" {
  name             = "IAMRoleStackSet1"
  template_body    = file("template.yaml")
  capabilities     = ["CAPABILITY_NAMED_IAM"]
  permission_model = "SERVICE_MANAGED"
  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }
}

resource "aws_cloudformation_stack_set_instance" "iam_role_stackset_instance" {
  stack_set_name = aws_cloudformation_stack_set.iam_role_stackset.name
  deployment_targets { organizational_unit_ids = ["ou-xu1h-b47tpq44"] }
}

data "external" "delete_vpc" {
  program = ["python3", "${path.module}/delete_vpc.py"]
  query = {
    new_account_id = aws_organizations_account.new_account.id
  }
  depends_on = [ aws_cloudformation_stack_set_instance.iam_role_stackset_instance.id ]
}

output "new_account_id" {
  value = aws_organizations_account.new_account.id
}
