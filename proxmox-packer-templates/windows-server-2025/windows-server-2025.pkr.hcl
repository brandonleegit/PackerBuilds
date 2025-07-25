# Windows Server 2025 Packer Template for Proxmox

packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "windows2025" {

  # Proxmox Host Connection
  proxmox_url              = var.proxmox_api_url
  insecure_skip_tls_verify = true
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  node                     = "REDACTED-NODE" # Replace with your Proxmox node's actual hostname

  # BIOS - UEFI
  bios    = "ovmf"
  machine = "q35"

  efi_config {
    efi_storage_pool  = "local-lvm"
    pre_enrolled_keys = true
  }

  # Windows Server ISO File
  iso_file    = "local:iso/win2025_unattend-noupdates.iso"
  unmount_iso = true

  additional_iso_files {

    device       = "ide3"                             # Mount as another CD-ROM
    iso_file     = "local:iso/virtio-win-0.1.262.iso" # Path to VirtIO ISO
    unmount      = true                               # Automatically unmount after build
    iso_checksum = "REDACTED-CHECKSUM"
  }

  # VM General Settings
  vm_name              = "win2025-template"
  template_name        = "win2025-template"
  template_description = "Windows Server 2025 Template"
  memory               = 4096 # Adjust memory as needed
  cores                = 2    # Adjust cores as needed
  cpu_type             = "host"
  os                   = "win11"
  scsi_controller      = "virtio-scsi-pci"
  qemu_agent           = true

  # Network Configuration
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0" # Replace with your actual bridge name
  }

  # Disk Configuration
  disks {
    storage_pool = "local-lvm"
    type         = "scsi"
    disk_size    = "40G"
    cache_mode   = "writeback"
    format       = "raw"
  }

  # WinRM Configuration
  communicator   = "winrm"
  winrm_username = "Administrator"
  winrm_password = var.admin_password
  winrm_timeout  = "12h"
  winrm_use_ssl  = false    # Ensure no SSL if using unsecured connections
  winrm_insecure = true     # Allow insecure connections

  # Boot Settings
  boot_wait = "3s"
  boot_command = [
    "<spacebar><spacebar>" # Simulate pressing "any key" to boot from CD-ROM
  ]
}

build {
  name    = "Proxmox Windows Server 2025 Build"
  sources = ["source.proxmox-iso.windows2025"]

}
