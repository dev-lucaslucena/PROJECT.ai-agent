variable "google_client_id" {
  description = "Google Client id stored in tf cloud"
  type        = string
  sensitive   = true
  default     = "GOOGLE_CLIENT_ID_PLACEHOLDER"
}

variable "google_client_secret" {
  description = "Google Client Secret stored in tf cloud"
  type        = string
  sensitive   = true
  default     = "GOOGLE_CLIENT_SECRET_PLACEHOLDER"
}

variable "google_client_provider" {
  description = "Google Client provider stored in tf cloud"
  type        = string
  sensitive   = true
  default     = "Google"
}