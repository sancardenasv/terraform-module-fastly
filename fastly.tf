resource "fastly_service_v1" "my-fastly-service" {
  name = var.fastly_service_name

  dynamic "domain" {
    for_each = var.domains
    content {
      name    = domain.value
      comment = "Serve using ${domain.value} domain"
    }
  }

  dynamic "backend" {
    for_each = var.backend
    content {
      name                = backend.value.name
      address             = backend.value.host
      port                = backend.value.port
      use_ssl             = backend.value.use_ssl
      ssl_check_cert      = "true"
      ssl_cert_hostname   = backend.value.ssl_host
      ssl_sni_hostname    = backend.value.ssl_host
      min_tls_version     = "1.2"
      connect_timeout     = "1000"
      max_conn            = "200"
      request_condition   = "${backend.value.name}_condition"
      auto_loadbalance    = backend.value.load_balance.enabled
      weight              = backend.value.load_balance.weight
      healthcheck         = "${backend.value.name}_healthcheck"
      override_host       = backend.value.host
    }
  }

  dynamic "condition" {
    for_each = var.backend
    content {
      name = "${condition.value.name}_condition"
      statement = condition.value.condition
      type = "REQUEST"
    }
  }

  dynamic "healthcheck" {
    for_each = var.backend
    content {
      name    = "${healthcheck.value.name}_healthcheck"
      host    = healthcheck.value.host
      path    = healthcheck.value.healthcheck_path
      method  = "HEAD"
      initial = 5
      timeout = 1000
    }
  }

  request_setting {
    name = "Force-SSL"
    force_ssl = var.force_ssl
  }
}
