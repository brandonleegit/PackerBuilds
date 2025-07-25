
variable "proxmox_api_url" {
  type = string
  default = "REDACTED-HOST:8006/api2/json"
}

variable "proxmox_api_token_id" {
  type = string
  default = "REDACTED-TOKEN-ID"
}

variable "proxmox_api_token_secret" {
  type = string
  default = "REDACTED-API-TOKEN"
  sensitive = true
}

