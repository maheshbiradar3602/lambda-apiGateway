//Lambda function Variables
variable "function_name" { type    = string }
variable "runtime_env_version" { type    = string }
variable "archive_file_type"  { type    = string }
variable "archive_file_source_file"  { type    = string }
variable "lambda_role"  { type    = string }
variable "lambda_policy"  { type    = string }
variable "lambda_function_timeout"  { type    = number }

#ApiGateway
variable "api_gw_rest_name"  { type    = string }
variable "api_gw_endpoint_confg"  { type    = string }
variable "api_gw_resource_path_part"  { type    = string }
variable "api_gw_method_http_method"  { type    = string }
variable "api_gw_method_http_authorization"  { type    = string }
variable "api_gw_method_http_key_required"  { type    = bool }
variable "api_gw_inegration_http_method"  { type    = string }
variable "api_gw_inegration_type"  { type    = string }
variable "api_gw_deployment_stage_name"  { type    = string }
variable "api_gw_method_response_status_code"  { type    = string }

variable "api_gw_usage_plan_name"  { type    = string }
variable "api_gw_api_key"  { type    = string }
variable "api_gw_usage_plan_key_type"  { type    = string }


#Provider region
variable "region"  { type    = string }