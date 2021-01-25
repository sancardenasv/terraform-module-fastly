output "service-metrics" {
  depends_on = [fastly_service_v1.fastly-service]
  value = "https://manage.fastly.com/stats/real-time/services/${fastly_service_v1.fastly-service.id}/datacenters/all"
}
