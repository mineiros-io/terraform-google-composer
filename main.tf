resource "google_composer_environment" "composer_environment" {
  count = var.module_enabled ? 1 : 0

  provider = google-beta

  project = var.project
  region  = var.region

  name   = var.name
  labels = var.labels

  config {
    node_count = var.node_count

    dynamic "software_config" {
      for_each = var.software_config != null ? [1] : []

      content {
        airflow_config_overrides = try(var.software_config.airflow_config_overrides, null) # - (Optional) Apache Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example "core-dags_are_paused_at_creation".    Section names must not contain hyphens ("-"), opening square brackets ("["), or closing square brackets ("]"). The property name must not be empty and cannot contain "=" or ";". Section and property names cannot contain characters: "." Apache Airflow configuration property names must be written in snake_case. Property values can contain any character, and can be written in any lower/upper case format. Certain Apache Airflow configuration property values are blacklisted, and cannot be overridden.
        pypi_packages            = try(var.software_config.pypi_packages, null)            # - (Optional) Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. "numpy"). Values are the lowercase extras and version specifier (e.g. "==1.12.0", "[devel,gcp_api]", "[devel]>=1.8.2, <1.9.2"). To specify a package without pinning it to a version specifier, use the empty string as the value.
        env_variables            = try(var.software_config.env_variables, null)            # - (Optional) Additional environment variables to provide to the Apache Airflow scheduler, worker, and webserver processes. Environment variable names must match the regular expression [a-zA-Z_][a-zA-Z0-9_]*. They cannot specify Apache Airflow software configuration overrides (they cannot match the regular expression AIRFLOW__[A-Z0-9_]+__[A-Z0-9_]+), and they cannot match any of the following reserved names:
        image_version            = try(var.software_config.image_version, null)            # (Optional) - The version of the software running in the environment. This encapsulates both the version of Cloud Composer functionality and the version of Apache Airflow. It must match the regular expression composer-[0-9]+\.[0-9]+(\.[0-9]+)?-airflow-[0-9]+\.[0-9]+(\.[0-9]+.*)?. The Cloud Composer portion of the version is a semantic version. The portion of the image version following 'airflow-' is an official Apache Airflow repository release name. See documentation for allowed release names.
        python_version           = try(var.software_config.python_version, null)           # (Optional) - The major version of Python used to run the Apache Airflow scheduler, worker, and webserver processes. Can be set to '2' or '3'. If not specified, the default is '2'. Cannot be updated.
      }
    }

    dynamic "private_environment_config" {
      for_each = var.private_environment_config != null ? [1] : []

      content {
        enable_private_endpoint    = try(var.private_environment_config.enable_private_endpoint, null)    # - If true, access to the public endpoint of the GKE cluster is denied.
        master_ipv4_cidr_block     = try(var.private_environment_config.master_ipv4_cidr_block, null)     # - (Optional) The IP range in CIDR notation to use for the hosted master network. This range is used for assigning internal IP addresses to the cluster master or set of masters and to the internal load balancer virtual IP. This range must not overlap with any other ranges in use within the cluster's network. If left blank, the default value of '172.16.0.0/28' is used.
        cloud_sql_ipv4_cidr_block  = try(var.private_environment_config.cloud_sql_ipv4_cidr_block, null)  # - (Optional) The CIDR block from which IP range in tenant project will be reserved for Cloud SQL. Needs to be disjoint from web_server_ipv4_cidr_block
        web_server_ipv4_cidr_block = try(var.private_environment_config.web_server_ipv4_cidr_block, null) # - (Optional) The CIDR block from which IP range for web server will be reserved. Needs to be disjoint from master_ipv4_cidr_block and cloud_sql_ipv4_cidr_block.
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
      for_each = var.node_config != null ? [1] : []

      content {
        zone = var.node_config.zone # - (Required) The Compute Engine zone in which to deploy the VMs running the Apache Airflow software, specified as the zone name or relative resource name (e.g. "projects/{project}/zones/{zone}"). Must belong to the enclosing environment's project and region.

        machine_type    = try(var.node_config.machine_type, null)    # - (Optional) The Compute Engine machine type used for cluster instances, specified as a name or relative resource name. For example: "projects/{project}/zones/{zone}/machineTypes/{machineType}". Must belong to the enclosing environment's project and region/zone.
        network         = try(var.node_config.network, null)         # - (Optional) The Compute Engine network to be used for machine communications, specified as a self-link, relative resource name (e.g. "projects/{project}/global/networks/{network}"), by name.      The network must belong to the environment's project. If unspecified, the "default" network ID in the environment's project is used. If a Custom Subnet Network is provided, subnetwork must also be provided.
        subnetwork      = try(var.node_config.subnetwork, null)      # - (Optional) The Compute Engine subnetwork to be used for machine communications, , specified as a self-link, relative resource name (e.g. "projects/{project}/regions/{region}/subnetworks/{subnetwork}"), or by name. If subnetwork is provided, network must also be provided and the subnetwork must belong to the enclosing environment's project and region.
        disk_size_gb    = try(var.node_config.disk_size_gb, null)    # - (Optional) The disk size in GB used for node VMs. Minimum size is 20GB. If unspecified, defaults to 100GB. Cannot be updated.
        oauth_scopes    = try(var.node_config.oauth_scopes, null)    # - (Optional) The set of Google API scopes to be made available on all node VMs. Cannot be updated. If empty, defaults to ["https://www.googleapis.com/auth/cloud-platform"]
        service_account = try(var.node_config.service_account, null) # - (Optional) The Google Cloud Platform Service Account to be used by the node VMs. If a service account is not specified, the "default" Compute Engine service account is used. Cannot be updated. If given, note that the service account must have roles/composer.worker for any GCP resources created under the Cloud Composer Environment.
        tags            = try(var.node_config.tags, null)            # - (Optional) The list of instance tags applied to all node VMs. Tags are used to identify valid sources or targets for network firewalls. Each tag within the list must comply with RFC1035. Cannot be updated.

        dynamic "ip_allocation_policy" {
          for_each = try(var.node_config.ip_allocation_policy.use_ip_aliases, null) == null ? [] : [
            var.node_config.ip_allocation_policy
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
  }
}
