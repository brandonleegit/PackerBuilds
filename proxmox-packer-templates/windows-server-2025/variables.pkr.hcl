# Windows Server-specific non-sensitive variables

variable "vm_name" {
  type    = string
  default = "windows-server-2025"
}

variable "disk_size" {
  type    = number
  default = 61440
}

variable "memory" {
  type    = number
  default = 4096
}

variable "cpus" {
  type    = number
  default = 2
}

variable "http_server_ip" {
  type    = string
  default = "REDACTED-IP"  # Replace with your actual IP
}

variable "http_server_port" {
  type    = number
  default = 8000             # Replace with your desired port
}