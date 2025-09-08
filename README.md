# Proxmox Windows VM Module

This Terraform module creates and configures a Windows virtual machine in Proxmox VE using the bpg/proxmox provider. It includes Windows-specific features like EFI disk, TPM state, VirtIO drivers ISO mounting, and proper UEFI/Secure Boot configuration.

## Features

- Windows VM creation optimized for modern Windows versions
- EFI disk and TPM 2.0 support
- Automatic VirtIO drivers ISO mounting
- Multiple network interfaces with VLAN support
- Additional disk attachments
- Hardware configuration (CPU, memory, storage)
- QEMU guest agent support

## Usage

```hcl
# Download VirtIO drivers ISO
resource "proxmox_virtual_environment_download_file" "virtio_drivers" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox-node-01"
  file_name    = "virtio-win.iso"
  url          = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
}

# Windows VM
module "windows_server" {
  source = "git@github.com:AndrewPaglusch/terraform-proxmox-windows-vm.git"

  vm_name               = "windows-server-2022"
  node_name             = "proxmox-node-01"
  vm_id                 = 300
  virtio_drivers_iso_id = proxmox_virtual_environment_download_file.virtio_drivers.id

  network = {
    vlan     = 100
    firewall = false
  }

  hardware = {
    disk_size = 100
    memory    = 8192
    cpu_cores = 4
    storage   = "local-lvm"
  }

  additional_disks = [
    {
      size      = 500
      interface = "virtio1"
      backup    = true
    }
  ]

  additional_networks = [
    {
      bridge  = "vmbr1"
      vlan_id = 200
      enabled = true
    }
  ]

  machine       = "pc-q35-8.1"
  bios          = "ovmf"
  cpu_type      = "x86-64-v2-AES"
  os_type       = "win11"
  agent_enabled = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| proxmox | ~> 0.66 |

## Providers

| Name | Version |
|------|---------|
| proxmox | ~> 0.66 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vm_name | Name of the VM | `string` | n/a | yes |
| node_name | Name of the Proxmox node | `string` | n/a | yes |
| vm_id | VM ID | `number` | n/a | yes |
| virtio_drivers_iso_id | VirtIO drivers ISO file ID | `string` | n/a | yes |
| hardware | Hardware configuration | `object({disk_size=number, memory=number, cpu_cores=number, storage=string})` | n/a | yes |
| network | Network configuration | `object({vlan=number, firewall=optional(bool)})` | n/a | yes |
| additional_disks | Additional disks to attach | `list(object({size=number, backup=optional(bool), interface=string, datastore_id=optional(string), file_format=optional(string)}))` | `[]` | no |
| additional_networks | Additional network interfaces | `list(object({bridge=string, vlan_id=optional(number), enabled=optional(bool), firewall=optional(bool), model=optional(string)}))` | `[]` | no |
| agent_enabled | Should Proxmox try to talk with a guest agent | `bool` | `true` | no |
| cpu_type | CPU type for the VM | `string` | `"x86-64-v4"` | no |
| cpu_sockets | Number of CPU sockets | `number` | `1` | no |
| os_type | Operating system type | `string` | `"win11"` | no |
| machine | Machine type | `string` | `"q35"` | no |
| bios | BIOS type | `string` | `"ovmf"` | no |

## Outputs

| Name | Description |
|------|-------------|
| vm_id | The VM ID |
| vm_name | The VM name |
| node_name | The node name where the VM is running |

## Windows-Specific Features

- **EFI Disk**: Automatically configured for UEFI boot support
- **TPM 2.0**: Required for Windows 11 and modern security features
- **VirtIO Drivers**: Automatically mounts the VirtIO drivers ISO as CD-ROM
- **Tablet Device**: Enabled for better mouse/touch integration
- **OVMF BIOS**: Default UEFI firmware for Windows compatibility

## Notes

- This module is specifically designed for Windows VMs and includes Windows-specific hardware configurations
- The VirtIO drivers ISO is downloaded automatically using the `proxmox_virtual_environment_download_file` resource
- EFI disk and TPM state are automatically configured but ignored in lifecycle to prevent unnecessary recreations
- Default OS type is `win11` but can be changed for other Windows versions
- QEMU guest agent is enabled by default
