locals{
  lambda_zip_location = "outputs/AzureCopy.zip"

}
data "archive_file" "AzureCopy" {
  type        = var.archive_file_type
  source_file = var.archive_file_source_file
  output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "azure_lambda" {
  filename      = "${local.lambda_zip_location}"
  function_name = var.function_name
  role          = "${aws_iam_role.azurelambda_role.arn}"
  handler       = "AzureCopy.lambda_handler"

  # source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = var.runtime_env_version
  timeout = var.lambda_function_timeout
  
}