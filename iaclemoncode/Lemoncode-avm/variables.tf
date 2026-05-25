variable "location" {
  type        = string
  description = "RG region"
}
variable "rsg_name" {
  type        = string
  description = "RG name in Azure"
}
variable "env_name_lc" {
  type        = string
  description = "Environment Name lowercase"
  validation {
    condition     = contains(["dev"], var.env_name_lc)
    error_message = "Value must be one of: dev"
  }
}