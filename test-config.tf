# Auth0 Terraform Deployment - Test Configuration

# This is a test configuration change to demonstrate the deployment pipeline
# Date: 2025-10-01
# Purpose: Validate GitHub Actions workflow deployment

# Test variables - these will be ignored but validate syntax
variable "test_deployment" {
  description = "Flag to indicate test deployment"
  type        = bool
  default     = true
}

variable "deployment_date" {
  description = "Date of deployment for testing"
  type        = string
  default     = "2025-10-01"
}

variable "pipeline_version" {
  description = "Pipeline version for testing"
  type        = string
  default     = "1.0.0"
}