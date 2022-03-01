locals{
  lambda_zip_location = "outputs/AzureCopy.zip"

}
data "archive_file" "AzureCopy" {
  type        = "zip"
  source_file = "AzureCopy.py"
  output_path = "${local.lambda_zip_location}"
}

resource "aws_lambda_function" "azure_lambda" {
  filename      = "${local.lambda_zip_location}"
  function_name = "AzureCopy"
  role          = "${aws_iam_role.azurelambda_role.arn}"
  handler       = "AzureCopy.lambda_handler"

  # source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.7"

  
}