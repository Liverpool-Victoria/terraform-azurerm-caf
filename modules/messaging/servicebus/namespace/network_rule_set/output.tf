output "id" {
  description = "The ID of the Service Bus Namespace (network rules are embedded in the namespace)."
  value       = var.remote_objects.servicebus_namespace_id
}
