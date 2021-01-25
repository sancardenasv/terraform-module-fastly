output "service-metrics" {
  depends_on = [fastly_service_v1.my-fastly-service]
  value = "https://manage.fastly.com/stats/real-time/services/${fastly_service_v1.my-fastly-service.id}/datacenters/all"
}
