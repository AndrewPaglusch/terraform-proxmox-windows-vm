variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "node_name" {
  description = "Name of the Proxmox node"
  type        = string
}

variable "vm_id" {
  description = "VM ID"
  type        = number
}

variable "agent_enabled" {
  description = "Should Promxox try to talk with a guest agent"
  type        = bool
  default     = true
}

variable "virtio_drivers_iso_id" {
  description = "VirtIO drivers ISO file ID"
  type        = string
}

variable "hardware" {
  description = "Hardware configuration"
  type = object({
    disk_size = number
    memory    = number
    cpu_cores = number
    storage   = string
  })
}

variable "additional_disks" {
  description = "Additional disks to attach"
  type = list(object({
    size         = number
    backup       = optional(bool, true)
    interface    = string
    datastore_id = optional(string)
    file_format  = optional(string, "raw")
  }))
  default = []
}

variable "cpu_type" {
  description = "CPU type for the VM"
  type        = string
  default     = "x86-64-v4"
}

variable "cpu_sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "os_type" {
  description = "Operating system type"
  type        = string
  default     = "win11"
}

variable "machine" {
  description = "Machine type"
  type        = string
  default     = "q35"
}

variable "bios" {
  description = "BIOS type"
  type        = string
  default     = "ovmf"
}

variable "network" {
  description = "Network configuration"
  type = object({
    vlan     = number
    firewall = optional(bool, false)
  })
}

variable "additional_networks" {
  description = "Additional network interfaces for bridge communication"
  type = list(object({
    bridge   = string
    vlan_id  = optional(number)
    enabled  = optional(bool, true)
    firewall = optional(bool, false)
    model    = optional(string, "virtio")
  }))
  default = []
}

