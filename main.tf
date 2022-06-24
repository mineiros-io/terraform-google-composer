resource "google_composer_environment" "composer_environment" {
  count = var.module_enabled ? 1 : 0

  depends_on = [var.module_depends_on]

  provider = google-beta

  project = var.project
  region  = var.region

  name   = var.name
  labels = var.labels

  config {
    node_count = var.node_count

    dynamic "software_config" {
      for_each = var.software_config != null ? [var.software_config] : []

      content {
        airflow_config_overrides = try(software_config.value.airflow_config_overrides, null)
        pypi_packages            = try(software_config.value.pypi_packages, null)
        env_variables            = try(software_config.value.env_variables, null)
        image_version            = try(software_config.value.image_version, null)
        python_version           = try(software_config.value.python_version, null)
        scheduler_count          = try(software_config.value.scheduler_count, null)
      }
    }

    dynamic "private_environment_config" {
      for_each = var.private_environment_config != null ? [var.private_environment_config] : []

      content {
        enable_private_endpoint    = try(private_environment_config.value.enable_private_endpoint, null)
        master_ipv4_cidr_block     = try(private_environment_config.value.master_ipv4_cidr_block, null)
        cloud_sql_ipv4_cidr_block  = try(private_environment_config.value.cloud_sql_ipv4_cidr_block, null)
        web_server_ipv4_cidr_block = try(private_environment_config.value.web_server_ipv4_cidr_block, null)
      }
    }

    dynamic "database_config" {
      for_each = var.database_machine_type != null ? [1] : []

      content {
        machine_type = var.database_machine_type # - (Required) Cloud SQL machine type used by Airflow database. It has to be one of: db-n1-standard-2, db-n1-standard-4, db-n1-standard-8 or db-n1-standard-16.
      }
    }

    dynamic "web_server_config" {
      for_each = var.webserver_machine_type != null ? [1] : []

      content {
        machine_type = var.webserver_machine_type # - (Required) Machine type on which Airflow web server is running. It has to be one of: composer-n1-webserver-2, composer-n1-webserver-4 or composer-n1-webserver-8. Value custom is returned only in response, if Airflow web server parameters were manually changed to a non-standard values.
      }
    }

    dynamic "web_server_network_access_control" {
      for_each = var.web_server_allowed_ip_ranges != null ? [1] : []

      content {
        dynamic "allowed_ip_range" {
          for_each = var.web_server_allowed_ip_ranges

          content {
            value       = allowed_ip_range.value.value
            description = try(allowed_ip_range.value.description, allowed_ip_range.value.value)
          }
        }
      }
    }

    dynamic "node_config" {
      for_each = var.node_config != null ? [var.node_config] : []

      content {
        zone = node_config.value.zone

        machine_type    = try(node_config.value.machine_type, null)
        network         = try(node_config.value.network, null)
        subnetwork      = try(node_config.value.subnetwork, null)
        disk_size_gb    = try(node_config.value.disk_size_gb, null)
        oauth_scopes    = try(node_config.value.oauth_scopes, null)
        service_account = try(node_config.value.service_account, null)
        tags            = try(node_config.value.tags, null)

        dynamic "ip_allocation_policy" {
          for_each = try(node_config.value.ip_allocation_policy.use_ip_aliases, null) == null ? [] : [
            node_config.value.ip_allocation_policy
          ]
          iterator = iap

          content {
            use_ip_aliases = iap.value.use_ip_aliases # - (Required) Whether or not to enable Alias IPs in the GKE cluster. If true, a VPC-native cluster is created. Defaults to true if the ip_allocation_policy block is present in config.

            # use_ip_aliases == true
            cluster_secondary_range_name  = try(iap.value.cluster_secondary_range_name, null)  # - (Optional) The name of the cluster's secondary range used to allocate IP addresses to pods. Specify either cluster_secondary_range_name or cluster_ipv4_cidr_block but not both. This field is applicable only when use_ip_aliases is true.
            services_secondary_range_name = try(iap.value.services_secondary_range_name, null) # - (Optional) The name of the services' secondary range used to allocate IP addresses to the cluster. Specify either services_secondary_range_name or services_ipv4_cidr_block but not both. This field is applicable only when use_ip_aliases is true.

            # conflicts with secondary range_names
            cluster_ipv4_cidr_block  = try(iap.value.cluster_ipv4_cidr_block, null)  # - (Optional) The IP address range used to allocate IP addresses to pods in the cluster. Set to blank to have GKE choose a range with the default size. Set to /netmask (e.g. /14) to have GKE choose a range with a specific netmask. Set to a CIDR notation (e.g. 10.96.0.0/14) from the RFC-1918 private networks (e.g. 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) to pick a specific range to use. Specify either cluster_secondary_range_name or cluster_ipv4_cidr_block but not both.
            services_ipv4_cidr_block = try(iap.value.services_ipv4_cidr_block, null) # - (Optional) The IP address range used to allocate IP addresses in this cluster. Set to blank to have GKE choose a range with the default size. Set to /netmask (e.g. /14) to have GKE choose a range with a specific netmask. Set to a CIDR notation (e.g. 10.96.0.0/14) from the RFC-1918 private networks (e.g. 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) to pick a specific range to use. Specify either services_secondary_range_name or services_ipv4_cidr_block but not both.
          }
        }
      }
    }

    dynamic "encryption_config" {
      for_each = var.kms_key_name != null ? [1] : []
      content {
        kms_key_name = var.kms_key_name # - (Required) Customer-managed Encryption Key available through Google's Key Management Service. It must be the fully qualified resource name, i.e. projects/project-id/locations/location/keyRings/keyring/cryptoKeys/key. Cannot be updated.
      }
    }

    dynamic "maintenance_window" {
      for_each = var.maintenance_window != null ? [var.maintenance_window] : []
      content {
        start_time = maintenance_window.value.start_time
        end_time   = maintenance_window.value.end_time
        recurrence = maintenance_window.value.recurrence
      }
    }
  }
}
