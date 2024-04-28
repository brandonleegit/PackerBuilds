
variable "proxmox_api_url" {
  type = string
  default = "https://10.1.149.199:8006/api2/json"
}

variable "proxmox_api_token_id" {
  type = string
  default = "root@pam!testtoken"
}

variable "proxmox_api_token_secret" {
  type = string
  default = "de7cd80c-cf3c-43fc-bd26-df6cf3b9c98c"
  sensitive = true
}

