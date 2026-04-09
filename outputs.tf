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

output "ip_address" {
  description = <<DESCRIPTION
  The IP address of created Ip Group.
  DESCRIPTION
  value       = [for ip in azapi_resource.this.body.properties.ipAddresses : ip]
}
