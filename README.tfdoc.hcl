header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-composer"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-composer/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-composer/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-composer.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-composer/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-composer"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create a [Google Cloud Composer](https://cloud.google.com/composer/docs/) on [Google Cloud Services (GCP)](https://cloud.google.com/).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      A [Terraform] base module for creating a `terraform-google-composer`. Google Cloud Composer is a fully managed workflow orchestration service built on Apache Airflow.
    END
  }

  section {
    title   = "Composer Versions"
    content = <<-END
      Google Cloud Composer has two [major versions](https://cloud.google.com/composer/docs/composer-2/composer-versioning-overview):
      Cloud Composer 1 and Cloud Composer 2. Some new Cloud Composer features might be supported only in Cloud Composer 2.
      For details please see: https://cloud.google.com/composer/docs/composer-2/composer-versioning-overview
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module just setting required arguments:

      ```hcl
      module "terraform-google-composer" {
        source = "git@github.com:mineiros-io/terraform-google-composer.git?ref=v0.1.0"

        name   = "example-name"

        software_config = {
          python_version = 3
        }
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Top-level Arguments"

      section {
        title = "Main Resource Configuration"

        variable "name" {
          type        = string
          required    = true
          description = <<-END
            The location or Compute Engine region for the environment.
          END
        }

        variable "project" {
          type        = string
          required    = true
          description = <<-END
            The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
          END
        }

        variable "region" {
          type        = string
          description = <<-END
            The location or Compute Engine region for the environment.
          END
        }

        variable "labels" {
          type        = map(string)
          description = <<-END
            User-defined labels for this environment. The labels map can contain no more than 64 entries. Entries of the labels map are UTF8 strings that comply with the following restrictions: Label keys must be between 1 and 63 characters long and must conform to the following regular expression: `[a-z]([-a-z0-9]*[a-z0-9])?`. Label values must be between 0 and 63 characters long and must conform to the regular expression `([a-z]([-a-z0-9]*[a-z0-9])?)?`. No more than 64 labels can be associated with a given environment. Both keys and values must be <= 128 bytes in size.
          END
        }

        variable "node_count" {
          type        = number
          description = <<-END
            The number of nodes in the Kubernetes Engine cluster that will be used to run this environment. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
          END
        }

        variable "software_config" {
          type        = object(software_config)
          description = <<-END
            The configuration settings for software inside the environment.
          END

          attribute "airflow_config_overrides" {
            type        = map(string)
            description = <<-END
              Apache Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example "core-dags_are_paused_at_creation".

              Section names must not contain hyphens ("`-`"), opening square brackets ("`[`"), or closing square brackets ("`]`"). The property name must not be empty and cannot contain "`=`" or "`;`". Section and property names cannot contain characters: "`.`" Apache Airflow configuration property names must be written in snake_case. Property values can contain any character, and can be written in any lower/upper case format. Certain Apache Airflow configuration property values are blacklisted, and cannot be overridden.
            END
          }

          attribute "pypi_packages" {
            type        = map(string)
            description = <<-END
              Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. "numpy"). Values are the lowercase extras and version specifier (e.g. "`==1.12.0`", "`[devel,gcp_api]`", "`[devel]>=1.8.2, <1.9.2`"). To specify a package without pinning it to a version specifier, use the empty string as the value.
            END
          }

          attribute "env_variables" {
            type        = map(string)
            description = <<-END
              Additional environment variables to provide to the Apache Airflow scheduler, worker, and webserver processes. Environment variable names must match the regular expression `[a-zA-Z_][a-zA-Z0-9_]*`. They cannot specify Apache Airflow software configuration overrides (they cannot match the regular expression `AIRFLOW__[A-Z0-9_]+__[A-Z0-9_]+)`, and they cannot match any of the following reserved names:

              ```
              AIRFLOW_HOME,
              C_FORCE_ROOT,
              CONTAINER_NAME,
              DAGS_FOLDER,
              GCP_PROJECT,
              GCS_BUCKET,
              GKE_CLUSTER_NAME,
              SQL_DATABASE,
              SQL_INSTANCE,
              SQL_PASSWORD,
              SQL_PROJECT,
              SQL_REGION,
              SQL_USER
              ```
            END
          }

          attribute "image_version" {
            type        = string
            description = <<-END
              The version of the software running in the environment. This encapsulates both the version of Cloud Composer functionality and the version of Apache Airflow. It must match the regular expression `composer-[0-9]+\.[0-9]+(\.[0-9]+)?-airflow-[0-9]+\.[0-9]+(\.[0-9]+.*)?`. The Cloud Composer portion of the version is a semantic version. The portion of the image version following '`airflow-`' is an official Apache Airflow repository release name.
            END
          }

          attribute "python_version" {
            type        = string
            description = <<-END
              The major version of Python used to run the Apache Airflow scheduler, worker, and webserver processes. Can be set to '2' or '3'. If not specified, the default is '3'.
            END
          }

          attribute "scheduler_count" {
            type        = number
            description = <<-END
              Cloud Composer 1 with Airflow 2 only.
              The number of schedulers for Airflow. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-2.*.*`.
            END
          }
        }

        variable "private_environment_config" {
          type        = object(private_environment_config)
          description = <<-END
            The configuration used for the Private IP Cloud Composer environment.
          END

          attribute "enable_private_endpoint" {
            type        = bool
            description = <<-END
              If true, access to the public endpoint of the GKE cluster is denied. If this field is set to true, ip_allocation_policy.use_ip_aliases must be set to true for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
            END
          }

          attribute "master_ipv4_cidr_block" {
            type        = string
            description = <<-END
              The IP range in CIDR notation to use for the hosted master network. This range is used for assigning internal IP addresses to the cluster master or set of masters and to the internal load balancer virtual IP. This range must not overlap with any other ranges in use within the cluster's network.
            END
            default     = "172.16.0.0/28"
          }

          attribute "cloud_sql_ipv4_cidr_block" {
            type        = string
            description = <<-END
              The CIDR block from which IP range in tenant project will be reserved for Cloud SQL. Needs to be disjoint from web_server_ipv4_cidr_block
            END
          }

          attribute "web_server_ipv4_cidr_block" {
            type        = string
            description = <<-END
              The CIDR block from which IP range for web server will be reserved. Needs to be disjoint from master_ipv4_cidr_block and cloud_sql_ipv4_cidr_block. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
            END
          }

          attribute "web_server_ipv4_cidr_block" {
            type        = string
            description = <<-END
              The CIDR block from which IP range for web server will be reserved. Needs to be disjoint from master_ipv4_cidr_block and cloud_sql_ipv4_cidr_block. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
            END
          }
        }

        variable "database_machine_type" {
          type        = string
          description = <<-END
            Cloud SQL machine type used by Airflow database. It has to be one of: db-n1-standard-2, db-n1-standard-4, db-n1-standard-8 or db-n1-standard-16.
          END
        }

        variable "webserver_machine_type" {
          type        = string
          description = <<-END
            Machine type on which Airflow web server is running. It has to be one of: composer-n1-webserver-2, composer-n1-webserver-4 or composer-n1-webserver-8. Value custom is returned only in response, if Airflow web server parameters were manually changed to a non-standard values.
          END
        }

        variable "web_server_allowed_ip_ranges" {
          type        = list(web_server_allowed_ip_range)
          description = <<-END
            A collection of allowed IP ranges with descriptions.
          END

          attribute "value" {
            type        = string
            required    = true
            description = <<-END
              IP address or range, defined using CIDR notation, of requests that this rule applies to. Examples: `192.168.1.1` or `192.168.0.0/16` or `2001:db8::/32` or `2001:0db8:0000:0042:0000:8a2e:0370:7334`. IP range prefixes should be properly truncated. For example, `1.2.3.4/24` should be truncated to `1.2.3.0/24`. Similarly, for IPv6, `2001:db8::1/32` should be truncated to `2001:db8::/32`.
            END
          }

          attribute "description" {
            type        = string
            description = <<-END
            A description of this ip range.
          END
          }
        }

        variable "node_config" {
          type        = object(node_config)
          description = <<-END
            The configuration used for the Kubernetes Engine cluster.
          END

          attribute "zone" {
            type        = string
            description = <<-END
              The Compute Engine zone in which to deploy the VMs running the Apache Airflow software, specified as the zone name or relative resource name (e.g. "`projects/{project}/zones/{zone}`"). Must belong to the enclosing environment's project and region. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
            END
          }

          attribute "machine_type" {
            type        = string
            description = <<-END
              The Compute Engine machine type used for cluster instances, specified as a name or relative resource name. For example: "`projects/{project}/zones/{zone}/machineTypes/{machineType}`". Must belong to the enclosing environment's project and region/zone. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
            END
          }

          attribute "network" {
            type        = string
            description = <<-END
              he Compute Engine network to be used for machine communications, specified as a self-link, relative resource name (for example "`projects/{project}/global/networks/{network}`"), by name.

              The network must belong to the environment's project. If unspecified, the "default" network ID in the environment's project is used. If a Custom Subnet Network is provided, subnetwork must also be provided.
            END
          }

          attribute "subnetwork" {
            type        = string
            description = <<-END
              The Compute Engine subnetwork to be used for machine communications, specified as a self-link, relative resource name (for example, "`projects/{project}/regions/{region}/subnetworks/{subnetwork}`"), or by name. If subnetwork is provided, network must also be provided and the subnetwork must belong to the enclosing environment's project and region.
            END
          }

          attribute "disk_size_gb" {
            type        = number
            description = <<-END
              The disk size in GB used for node VMs. Minimum size is 20GB. If unspecified, defaults to 100GB. Cannot be updated. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
            END
          }

          attribute "oauth_scopes" {
            type        = set(string)
            description = <<-END
              The set of Google API scopes to be made available on all node VMs. Cannot be updated. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
            END
            default     = ["https://www.googleapis.com/auth/cloud-platform"]
          }

          attribute "service_account" {
            type        = string
            description = <<-END
              The Google Cloud Platform Service Account to be used by the node VMs. If a service account is not specified, the "default" Compute Engine service account is used. Cannot be updated. If given, note that the service account must have roles/composer.worker for any GCP resources created under the Cloud Composer Environment.
            END
          }

          attribute "tags" {
            type        = set(string)
            description = <<-END
              The list of instance tags applied to all node VMs. Tags are used to identify valid sources or targets for network firewalls. Each tag within the list must comply with RFC1035. Cannot be updated. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
            END
          }

          attribute "ip_allocation_policy" {
            type        = object(ip_allocation_policy)
            description = <<-END
              Configuration for controlling how IPs are allocated in the GKE cluster.
            END

            attribute "use_ip_aliases" {
              type        = bool
              description = <<-END
                Whether or not to enable Alias IPs in the GKE cluster. If true, a VPC-native cluster is created. Defaults to true if the ip_allocation_policy block is present in config.
              END
            }

            attribute "cluster_secondary_range_name" {
              type        = string
              description = <<-END
                The name of the cluster's secondary range used to allocate IP addresses to pods. Specify either `cluster_secondary_range_name` or `cluster_ipv4_cidr_block` but not both. For Cloud Composer 1 environments, this field is applicable only when `use_ip_aliases` is `true`.
              END
            }

            attribute "services_secondary_range_name" {
              type        = string
              description = <<-END
                The name of the services' secondary range used to allocate IP addresses to the cluster. Specify either services_secondary_range_name or services_ipv4_cidr_block but not both. For Cloud Composer 1 environments, this field is applicable only when use_ip_aliases is true.
              END
            }

            attribute "cluster_ipv4_cidr_block" {
              type        = string
              description = <<-END
                The IP address range used to allocate IP addresses to pods in the cluster. For Cloud Composer 1 environments, this field is applicable only when use_ip_aliases is true. Set to blank to have GKE choose a range with the default size. Set to /netmask (e.g. `/14`) to have GKE choose a range with a specific netmask. Set to a CIDR notation (e.g. `10.96.0.0/14`) from the RFC-1918 private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) to pick a specific range to use. Specify either cluster_secondary_range_name or cluster_ipv4_cidr_block but not both.
              END
            }

            attribute "cluster_ipv4_cidr_block" {
              type        = string
              description = <<-END
                The IP address range used to allocate IP addresses in this cluster. For Cloud Composer 1 environments, this field is applicable only when use_ip_aliases is true. Set to blank to have GKE choose a range with the default size. Set to /netmask (e.g. `/14`) to have GKE choose a range with a specific netmask. Set to a CIDR notation (e.g. `10.96.0.0/14`) from the RFC-1918 private networks (e.g. `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) to pick a specific range to use. Specify either services_secondary_range_name or services_ipv4_cidr_block but not both.
              END
            }
          }

          attribute "max_pods_per_node" {
            type        = number
            description = <<-END
              The maximum pods per node in the GKE cluster allocated during environment creation. Lowering this value reduces IP address consumption by the Cloud Composer Kubernetes cluster. This value can only be set during environment creation, and only if the environment is VPC-Native. The range of possible values is 8-110, and the default is 32. Cannot be updated. This field is supported for Cloud Composer environments in versions `composer-1.*.*-airflow-*.*.*`.
            END
          }

          attribute "enable_ip_masq_agent" {
            type        = bool
            description = <<-END
              Deploys 'ip-masq-agent' daemon set in the GKE cluster and defines nonMasqueradeCIDRs equals to pod IP range so IP masquerading is used for all destination addresses, except between pods traffic. See: https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent
            END
          }
        }

        variable "kms_key_name" {
          type        = string
          required    = true
          description = <<-END
            Customer-managed Encryption Key available through Google's Key Management Service. It must be the fully qualified resource name, i.e. `projects/project-id/locations/location/keyRings/keyring/cryptoKeys/key`. Cannot be updated.
          END
        }

        variable "maintenance_window" {
          type        = object(maintenance_window)
          description = "(Optional) The configuration settings for Cloud Composer maintenance windows."

          attribute "start_time" {
            type        = string
            description = <<-END
              (Required) Start time of the first recurrence of the maintenance window
            END
          }

          attribute "end_time" {
            type        = string
            description = <<-END
              (Required) Maintenance window end time. It is used only to calculate the duration of the maintenance window. The value for end-time must be in the future, relative to 'start_time'.
            END
          }

          attribute "recurrence" {
            type        = string
            description = <<-END
              (Required) Maintenance window recurrence. Format is a subset of RFC-5545 (https://tools.ietf.org/html/rfc5545) 'RRULE'. The only allowed values for 'FREQ' field are 'FREQ=DAILY' and 'FREQ=WEEKLY;BYDAY=…'. Example values: 'FREQ=WEEKLY;BYDAY=TU,WE', 'FREQ=DAILY'.
            END
          }
        }
      }

      section {
        title = "Module Configuration"

        variable "module_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Specifies whether resources in the module will be created.
          END
        }

        variable "module_depends_on" {
          type           = list(dependency)
          description    = <<-END
            A list of dependencies.
            Any object can be _assigned_ to this list to define a hidden external dependency.
          END
          default        = []
          readme_example = <<-END
            module_depends_on = [
              null_resource.name
            ]
          END
        }
      }
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - https://cloud.google.com/composer/docs
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-composer"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-composer/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-composer/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-composer/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-composer/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-composer/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-composer/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-composer/blob/main/CONTRIBUTING.md"
  }
}
