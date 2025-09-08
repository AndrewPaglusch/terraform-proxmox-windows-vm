resource "proxmox_virtual_environment_vm" "windows_vm" {
  name        = var.vm_name
  node_name   = var.node_name
  vm_id       = var.vm_id
  description = "Managed by Terraform"

  bios    = var.bios
  machine = var.machine

  cpu {
    cores   = var.hardware.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.hardware.memory
  }

  disk {
    datastore_id = var.hardware.storage
    interface    = "virtio0"
    size         = var.hardware.disk_size
    file_format  = "raw"
  }

  dynamic "disk" {
    for_each = var.additional_disks
    content {
      datastore_id = disk.value.datastore_id != null ? disk.value.datastore_id : var.hardware.storage
      file_format  = disk.value.file_format
      interface    = disk.value.interface
      size         = disk.value.size
      backup       = disk.value.backup
    }
  }

  # Add VirtIO drivers ISO as CD-ROM
  cdrom {
    file_id   = var.virtio_drivers_iso_id
    interface = "ide0"
  }

  network_device {
    bridge   = "vmbr0"
    vlan_id  = var.network.vlan
    enabled  = true
    firewall = var.network.firewall
    model    = "virtio"
  }

  dynamic "network_device" {
    for_each = var.additional_networks
    content {
      bridge   = network_device.value.bridge
      vlan_id  = network_device.value.vlan_id
      enabled  = network_device.value.enabled
      firewall = network_device.value.firewall
      model    = network_device.value.model
    }
  }

  operating_system {
    type = var.os_type
  }

  agent {
    enabled = var.agent_enabled
    trim    = true
  }

  efi_disk {
    datastore_id = var.hardware.storage
    file_format  = "raw"
    type         = "4m"
  }

  tpm_state {
    datastore_id = var.hardware.storage
    version      = "v2.0"
  }

  tablet_device = true

  lifecycle {
    ignore_changes = [
      disk,
      efi_disk,
    ]
  }
}
