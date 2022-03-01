#Lambda function Variables
function_name = "MaheshAzureCopy"
runtime_env_version = "python3.7"
lambda_function_timeout = 120
archive_file_type = "zip"
archive_file_source_file = "AzureCopy.py"
lambda_role = "Maheshazure_copy"
lambda_policy = "Maheshtest_policy"

#ApiGateway
api_gw_rest_name = "MaheshazureCopytf"
api_gw_endpoint_confg = "REGIONAL"
api_gw_resource_path_part = "MaheshazureCopy"
api_gw_method_http_method = "PUT"
api_gw_method_http_authorization = "NONE"
api_gw_method_http_key_required = true
api_gw_inegration_http_method = "PUT"
api_gw_inegration_type = "AWS"
api_gw_deployment_stage_name = "MaheshazureCopytf"
api_gw_method_response_status_code = "200"

api_gw_usage_plan_name = "Maheshazure_Plantf"
api_gw_api_key = "Maheshazure_key"
api_gw_usage_plan_key_type = "API_KEY"


#Provider region
region = "us-east-1"
