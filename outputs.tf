output "vm_id" {
  description = "The VM ID"
  value       = proxmox_virtual_environment_vm.windows_vm.vm_id
}

output "vm_name" {
  description = "The VM name"
  value       = proxmox_virtual_environment_vm.windows_vm.name
}

output "node_name" {
  description = "The node name where the VM is running"
  value       = proxmox_virtual_environment_vm.windows_vm.node_name
}