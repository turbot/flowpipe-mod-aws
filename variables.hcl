variable "region" {
  type        = string
  description = "The name of the Region."
  default     = ""
}

variable "access_key_id" {
  type        = string
  description = "The ID for this access key."
  default     = ""
}

variable "secret_access_key" {
  type        = string
  description = "The secret key used to sign requests."
  default     = ""
}

variable "session_token" {
  type        = string
  description = "If needing an AWS session token."
  default     = ""
}