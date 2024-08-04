output "vm_public_ip" {
  value = outscale_vm.vm_public.public_ip
}

output "vm_private_id" {
  value = outscale_vm.vm_private.private_ip
}
