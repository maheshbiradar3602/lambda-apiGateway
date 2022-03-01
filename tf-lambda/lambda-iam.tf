resource "aws_iam_role_policy" "lambda_policy" {
  name = var.lambda_policy
  role = aws_iam_role.azurelambda_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = "${file("iam/lambdapolicy.json")}"
}

resource "aws_iam_role" "azurelambda_role" {
  name = var.lambda_role

  assume_role_policy = "${file("iam/lambda-assume-policy.json")}"
}