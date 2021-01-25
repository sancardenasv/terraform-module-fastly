# Fastly service base project
This module can be used to create a Fastly service with multiple options;
Fastly is a CDN service that allows you to route resources from multiple domains to multiple origins or backends.
In this service, you can build:
- Multiple domains
- Multiple backends
- Backend Health Check.
- Route criteria.
- Load balance.

### Usage
Include the module inside your Terraform configuration with required and desired input variables.
Also include the Fastly provider.
```
# This is the token to communicate with the Fastly API.
provider "fastly" {
  api_key = var.fastly_api_token # This should not be public.
}

module "fastly" {
  source = "git@github.com:sancardenasv/terraform-module-fastly.git"
  
  fastly_service_name   = var.fastly_service_name # Unique name for the service in Fastly.
  domains               = var.domains # List of domains to access the service.
  force_ssl             = var.force_ssl # Turn HTTP request to HTTPS.
  backend               = var.backend # Servers where to find the requested resources.
}
```

#### Fastly API Token
This is the token used to authenticate with Fastly API. Do not set it on plain sight, use GitLab
`Environment Variables` under Settings.CI/CD panel and then provide in the pipeline the terraformer
command with it; for example:
```
terraformer plan -var fastly_api_token=$FASTLY_API_TOKEN
```
#### Service Name
This is the name of the service that will be created in Fastly; ensure it is unique enough to avoid collisions.

#### Domains
These are used as entry points to serve resources; through these you will be accessing the resources, that is why
you need to create a DNS mapping called <domain>.global.prod.fastly.net.
Create a DNS alias for the domain name you specified, for example:
```
CNAME domain.example.com to global-nossl.fastly.net
```
Domains variable is a list; hence, needs to be in the form of `["domain1", "domain2"]`

#### Backend
The backend is the resource server where Fastly will search for the requested resources using the domains configured.
Configuration supports multiple backends that can latter be configured using `Conditions` or `Load Balancing`.

The basic object is defined as:
```
    name = string               # Name to identify the resource server in Fastly
    host = string               # Domain of the resource server (without pathing)
    port = number               # Port used to access the server
    use_ssl = bool              # On true will perform request using HTTPS
    ssl_host = string           # Set domain that is registered in the certificate if use_ssl set
    healthcheck_path = string   # Path used to perform HEAD request on health check
    condition = string          # Use to diferentiate which backend to lookup
    load_balance = object({
      enabled = bool            # If enabled, Fastly will balance between backends that has the same condition
      weight = number           # Trafic balance from 0 to 100
    }
```

###### Conditions
Request conditions can be set in each `backend.condition` variable to filter backend resources;
the condition can be an expression or regex and can use multiple parameters.
You can read more on Fastly documentation page [here](https://docs.fastly.com/en/guides/using-conditions).

###### Load Balancer
When you specify a whole number in the Weight field, you specify the percentage of the total traffic to send
to a specific origin server. For example, to split the traffic equally between two origin servers, setting
the weight to 50 on both will do.

You can create a subset of backends to balance the traffic using the same condition on those, as Fastly
will balance between those that apply under it.