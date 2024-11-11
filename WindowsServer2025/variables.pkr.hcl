variable "cpu_num" {
  type    = string
  default = ""
}

variable "disk_size" {
  type    = string
  default = ""
}

variable "mem_size" {
  type    = string
  default = ""
}

variable "os_iso_path" {
  type    = string
  default = ""
}

variable "vmtools_iso_path" {
  type    = string
  default = ""
}

variable "vsphere_compute_cluster" {
  type    = string
  default = ""
}

variable "vsphere_datastore" {
  type    = string
  default = ""
}

variable "vsphere_dc_name" {
  type    = string
  default = ""
}

variable "vsphere_folder" {
  type    = string
  default = ""
}

variable "vsphere_host" {
  type    = string
  default = ""
}

variable "vsphere_portgroup_name" {
  type    = string
  default = ""
}

variable "vsphere_server" {
  type    = string
  default = ""
}

variable "vsphere_template_name" {
  type    = string
  default = ""
}

variable "vsphere_user" {
  type    = string
  default = ""
}

variable "winadmin_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "vm_disk_controller_type" {
  type        = list(string)
  description = "The virtual disk controller types in sequence. (e.g. 'pvscsi')"
  default     = ["pvscsi"]
}