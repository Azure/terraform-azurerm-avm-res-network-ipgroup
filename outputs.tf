output "name" {
  description = <<DESCRIPTION
  The Name of Ip Group.
  DESCRIPTION
  value       = azapi_resource.this.name
}

output "resource_id" {
  description = <<DESCRIPTION
  The ID of created Ip Group.
  DESCRIPTION
  value       = azapi_resource.this.id
}
