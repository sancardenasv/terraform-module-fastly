output "fastly_service_name" {
  value = fastly_service_v1.fastly-service.name
}

output "service_id" {
  value = fastly_service_v1.fastly-service.id
}

output "service_version" {
  value = fastly_service_v1.fastly-service.active_version
}

output "configured_domains" {
  value = fastly_service_v1.fastly-service.domain
}

output "service_dashboard" {
  depends_on = [fastly_service_v1.fastly-service]
  value = "https://manage.fastly.com/stats/real-time/services/${fastly_service_v1.fastly-service.id}/datacenters/all"
}
