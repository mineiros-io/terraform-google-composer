[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-composer)

[![Build Status](https://github.com/mineiros-io/terraform-google-composer/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-composer/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-composer.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-composer/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-composer

A [Terraform](https://www.terraform.io) module to create a [Google Cloud Composer](https://cloud.google.com/composer/docs/) on [Google Cloud Services (GCP)](https://cloud.google.com/).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

A [Terraform] base module for creating a `terraform-google-composer`. Composer is a managed Apache Airflow

## Getting Started

Most common usage of the module just setting required arguments:

```hcl
module "terraform-google-composer" {
  source = "git@github.com:mineiros-io/terraform-google-composer.git?ref=v0.0.1"

  name    = "example-name"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Main Resource Configuration

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  The location or Compute Engine region for the environment.

- [**`project`**](#var-project): *(**Required** `string`)*<a name="var-project"></a>

  The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- [**`region`**](#var-region): *(Optional `string`)*<a name="var-region"></a>

  The location or Compute Engine region for the environment.

- [**`labels`**](#var-labels): *(Optional `map(string)`)*<a name="var-labels"></a>

  User-defined labels for this environment. The labels map can contain no more than 64 entries. Entries of the labels map are UTF8 strings that comply with the following restrictions: Label keys must be between 1 and 63 characters long and must conform to the following regular expression: [a-z]([-a-z0-9]*[a-z0-9])?. Label values must be between 0 and 63 characters long and must conform to the regular expression ([a-z]([-a-z0-9]*[a-z0-9])?)?. No more than 64 labels can be associated with a given environment. Both keys and values must be <= 128 bytes in size.

- [**`node_count`**](#var-node_count): *(Optional `number`)*<a name="var-node_count"></a>

  The number of nodes in the Kubernetes Engine cluster that will be used to run this environment. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

- [**`software_config`**](#var-software_config): *(Optional `object(software_config)`)*<a name="var-software_config"></a>

  The configuration settings for software inside the environment.

  The object accepts the following attributes:

  - [**`airflow_config_overrides`**](#attr-airflow_config_overrides-1): *(Optional `map(string)`)*<a name="attr-airflow_config_overrides-1"></a>

    Apache Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example "core-dags_are_paused_at_creation".
    
    Section names must not contain hyphens ("-"), opening square brackets ("["), or closing square brackets ("]"). The property name must not be empty and cannot contain "=" or ";". Section and property names cannot contain characters: "." Apache Airflow configuration property names must be written in snake_case. Property values can contain any character, and can be written in any lower/upper case format. Certain Apache Airflow configuration property values are blacklisted, and cannot be overridden.

  - [**`pypi_packages`**](#attr-pypi_packages-1): *(Optional `map(string)`)*<a name="attr-pypi_packages-1"></a>

    Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. "numpy"). Values are the lowercase extras and version specifier (e.g. "==1.12.0", "[devel,gcp_api]", "[devel]>=1.8.2, <1.9.2"). To specify a package without pinning it to a version specifier, use the empty string as the value.

  - [**`env_variables`**](#attr-env_variables-1): *(Optional `map(string)`)*<a name="attr-env_variables-1"></a>

    Additional environment variables to provide to the Apache Airflow scheduler, worker, and webserver processes. Environment variable names must match the regular expression [a-zA-Z_][a-zA-Z0-9_]*. They cannot specify Apache Airflow software configuration overrides (they cannot match the regular expression AIRFLOW__[A-Z0-9_]+__[A-Z0-9_]+), and they cannot match any of the following reserved names:
    
    AIRFLOW_HOME
    C_FORCE_ROOT
    CONTAINER_NAME
    DAGS_FOLDER
    GCP_PROJECT
    GCS_BUCKET
    GKE_CLUSTER_NAME
    SQL_DATABASE
    SQL_INSTANCE
    SQL_PASSWORD
    SQL_PROJECT
    SQL_REGION
    SQL_USER

  - [**`image_version`**](#attr-image_version-1): *(Optional `string`)*<a name="attr-image_version-1"></a>

    The version of the software running in the environment. This encapsulates both the version of Cloud Composer functionality and the version of Apache Airflow. It must match the regular expression composer-[0-9]+\.[0-9]+(\.[0-9]+)?-airflow-[0-9]+\.[0-9]+(\.[0-9]+.*)?. The Cloud Composer portion of the version is a semantic version. The portion of the image version following 'airflow-' is an official Apache Airflow repository release name.

  - [**`python_version`**](#attr-python_version-1): *(Optional `string`)*<a name="attr-python_version-1"></a>

    The major version of Python used to run the Apache Airflow scheduler, worker, and webserver processes. Can be set to '2' or '3'. If not specified, the default is '3'.

  - [**`scheduler_count`**](#attr-scheduler_count-1): *(Optional `number`)*<a name="attr-scheduler_count-1"></a>

    The number of schedulers for Airflow. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-2.*.*.

- [**`private_environment_config`**](#var-private_environment_config): *(Optional `object(private_environment_config)`)*<a name="var-private_environment_config"></a>

  The configuration used for the Private IP Cloud Composer environment.

  The object accepts the following attributes:

  - [**`enable_private_endpoint`**](#attr-enable_private_endpoint-1): *(Optional `bool`)*<a name="attr-enable_private_endpoint-1"></a>

    If true, access to the public endpoint of the GKE cluster is denied. If this field is set to true, ip_allocation_policy.use_ip_aliases must be set to true for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

  - [**`master_ipv4_cidr_block`**](#attr-master_ipv4_cidr_block-1): *(Optional `string`)*<a name="attr-master_ipv4_cidr_block-1"></a>

    The IP range in CIDR notation to use for the hosted master network. This range is used for assigning internal IP addresses to the cluster master or set of masters and to the internal load balancer virtual IP. This range must not overlap with any other ranges in use within the cluster's network.

    Default is `"172.16.0.0/28"`.

  - [**`cloud_sql_ipv4_cidr_block`**](#attr-cloud_sql_ipv4_cidr_block-1): *(Optional `string`)*<a name="attr-cloud_sql_ipv4_cidr_block-1"></a>

    The CIDR block from which IP range in tenant project will be reserved for Cloud SQL. Needs to be disjoint from web_server_ipv4_cidr_block

  - [**`web_server_ipv4_cidr_block`**](#attr-web_server_ipv4_cidr_block-1): *(Optional `string`)*<a name="attr-web_server_ipv4_cidr_block-1"></a>

    The CIDR block from which IP range for web server will be reserved. Needs to be disjoint from master_ipv4_cidr_block and cloud_sql_ipv4_cidr_block. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

  - [**`web_server_ipv4_cidr_block`**](#attr-web_server_ipv4_cidr_block-1): *(Optional `string`)*<a name="attr-web_server_ipv4_cidr_block-1"></a>

    The CIDR block from which IP range for web server will be reserved. Needs to be disjoint from master_ipv4_cidr_block and cloud_sql_ipv4_cidr_block. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

- [**`database_machine_type`**](#var-database_machine_type): *(Optional `string`)*<a name="var-database_machine_type"></a>

  Cloud SQL machine type used by Airflow database. It has to be one of: db-n1-standard-2, db-n1-standard-4, db-n1-standard-8 or db-n1-standard-16.

- [**`webserver_machine_type`**](#var-webserver_machine_type): *(Optional `string`)*<a name="var-webserver_machine_type"></a>

  Machine type on which Airflow web server is running. It has to be one of: composer-n1-webserver-2, composer-n1-webserver-4 or composer-n1-webserver-8. Value custom is returned only in response, if Airflow web server parameters were manually changed to a non-standard values.

- [**`web_server_allowed_ip_ranges`**](#var-web_server_allowed_ip_ranges): *(Optional `list(web_server_allowed_ip_ranges)`)*<a name="var-web_server_allowed_ip_ranges"></a>

  A collection of allowed IP ranges with descriptions.

  The object accepts the following attributes:

  - [**`value`**](#attr-value-1): *(**Required** `string`)*<a name="attr-value-1"></a>

    IP address or range, defined using CIDR notation, of requests that this rule applies to. Examples: 192.168.1.1 or 192.168.0.0/16 or 2001:db8::/32 or 2001:0db8:0000:0042:0000:8a2e:0370:7334. IP range prefixes should be properly truncated. For example, 1.2.3.4/24 should be truncated to 1.2.3.0/24. Similarly, for IPv6, 2001:db8::1/32 should be truncated to 2001:db8::/32.

  - [**`description`**](#attr-description-1): *(Optional `string`)*<a name="attr-description-1"></a>

    A description of this ip range.

- [**`node_config`**](#var-node_config): *(Optional `object(node_config)`)*<a name="var-node_config"></a>

  The configuration used for the Kubernetes Engine cluster.

  The object accepts the following attributes:

  - [**`zone`**](#attr-zone-1): *(Optional `string`)*<a name="attr-zone-1"></a>

    The Compute Engine zone in which to deploy the VMs running the Apache Airflow software, specified as the zone name or relative resource name (e.g. "projects/{project}/zones/{zone}"). Must belong to the enclosing environment's project and region. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

  - [**`machine_type`**](#attr-machine_type-1): *(Optional `string`)*<a name="attr-machine_type-1"></a>

    The Compute Engine machine type used for cluster instances, specified as a name or relative resource name. For example: "projects/{project}/zones/{zone}/machineTypes/{machineType}". Must belong to the enclosing environment's project and region/zone. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

  - [**`network`**](#attr-network-1): *(Optional `string`)*<a name="attr-network-1"></a>

    he Compute Engine network to be used for machine communications, specified as a self-link, relative resource name (for example "projects/{project}/global/networks/{network}"), by name.
    
    The network must belong to the environment's project. If unspecified, the "default" network ID in the environment's project is used. If a Custom Subnet Network is provided, subnetwork must also be provided.

  - [**`subnetwork`**](#attr-subnetwork-1): *(Optional `string`)*<a name="attr-subnetwork-1"></a>

    The Compute Engine subnetwork to be used for machine communications, specified as a self-link, relative resource name (for example, "projects/{project}/regions/{region}/subnetworks/{subnetwork}"), or by name. If subnetwork is provided, network must also be provided and the subnetwork must belong to the enclosing environment's project and region.

  - [**`disk_size_gb`**](#attr-disk_size_gb-1): *(Optional `number`)*<a name="attr-disk_size_gb-1"></a>

    The disk size in GB used for node VMs. Minimum size is 20GB. If unspecified, defaults to 100GB. Cannot be updated. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

  - [**`oauth_scopes`**](#attr-oauth_scopes-1): *(Optional `set(string)`)*<a name="attr-oauth_scopes-1"></a>

    The set of Google API scopes to be made available on all node VMs. Cannot be updated. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

    Default is `["https://www.googleapis.com/auth/cloud-platform"]`.

  - [**`service_account`**](#attr-service_account-1): *(Optional `string`)*<a name="attr-service_account-1"></a>

    The Google Cloud Platform Service Account to be used by the node VMs. If a service account is not specified, the "default" Compute Engine service account is used. Cannot be updated. If given, note that the service account must have roles/composer.worker for any GCP resources created under the Cloud Composer Environment.

  - [**`tags`**](#attr-tags-1): *(Optional `set(string)`)*<a name="attr-tags-1"></a>

    The list of instance tags applied to all node VMs. Tags are used to identify valid sources or targets for network firewalls. Each tag within the list must comply with RFC1035. Cannot be updated. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

  - [**`ip_allocation_policy`**](#attr-ip_allocation_policy-1): *(Optional `object(ip_allocation_policy)`)*<a name="attr-ip_allocation_policy-1"></a>

    Configuration for controlling how IPs are allocated in the GKE cluster.

    The object accepts the following attributes:

    - [**`use_ip_aliases`**](#attr-use_ip_aliases-2): *(Optional `bool`)*<a name="attr-use_ip_aliases-2"></a>

      Whether or not to enable Alias IPs in the GKE cluster. If true, a VPC-native cluster is created. Defaults to true if the ip_allocation_policy block is present in config.

    - [**`cluster_secondary_range_name`**](#attr-cluster_secondary_range_name-2): *(Optional `string`)*<a name="attr-cluster_secondary_range_name-2"></a>

      The name of the cluster's secondary range used to allocate IP addresses to pods. Specify either cluster_secondary_range_name or cluster_ipv4_cidr_block but not both. For Cloud Composer 1 environments, this field is applicable only when use_ip_aliases is true.

    - [**`services_secondary_range_name`**](#attr-services_secondary_range_name-2): *(Optional `string`)*<a name="attr-services_secondary_range_name-2"></a>

      The name of the services' secondary range used to allocate IP addresses to the cluster. Specify either services_secondary_range_name or services_ipv4_cidr_block but not both. For Cloud Composer 1 environments, this field is applicable only when use_ip_aliases is true.

    - [**`cluster_ipv4_cidr_block`**](#attr-cluster_ipv4_cidr_block-2): *(Optional `string`)*<a name="attr-cluster_ipv4_cidr_block-2"></a>

      The IP address range used to allocate IP addresses to pods in the cluster. For Cloud Composer 1 environments, this field is applicable only when use_ip_aliases is true. Set to blank to have GKE choose a range with the default size. Set to /netmask (e.g. /14) to have GKE choose a range with a specific netmask. Set to a CIDR notation (e.g. 10.96.0.0/14) from the RFC-1918 private networks (e.g. 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) to pick a specific range to use. Specify either cluster_secondary_range_name or cluster_ipv4_cidr_block but not both.

    - [**`cluster_ipv4_cidr_block`**](#attr-cluster_ipv4_cidr_block-2): *(Optional `string`)*<a name="attr-cluster_ipv4_cidr_block-2"></a>

      The IP address range used to allocate IP addresses in this cluster. For Cloud Composer 1 environments, this field is applicable only when use_ip_aliases is true. Set to blank to have GKE choose a range with the default size. Set to /netmask (e.g. /14) to have GKE choose a range with a specific netmask. Set to a CIDR notation (e.g. 10.96.0.0/14) from the RFC-1918 private networks (e.g. 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) to pick a specific range to use. Specify either services_secondary_range_name or services_ipv4_cidr_block but not both.

  - [**`max_pods_per_node`**](#attr-max_pods_per_node-1): *(Optional `number`)*<a name="attr-max_pods_per_node-1"></a>

    The maximum pods per node in the GKE cluster allocated during environment creation. Lowering this value reduces IP address consumption by the Cloud Composer Kubernetes cluster. This value can only be set during environment creation, and only if the environment is VPC-Native. The range of possible values is 8-110, and the default is 32. Cannot be updated. This field is supported for Cloud Composer environments in versions composer-1.*.*-airflow-*.*.*.

  - [**`enable_ip_masq_agent`**](#attr-enable_ip_masq_agent-1): *(Optional `bool`)*<a name="attr-enable_ip_masq_agent-1"></a>

    Deploys 'ip-masq-agent' daemon set in the GKE cluster and defines nonMasqueradeCIDRs equals to pod IP range so IP masquerading is used for all destination addresses, except between pods traffic. See: https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent

- [**`kms_key_name`**](#var-kms_key_name): *(**Required** `string`)*<a name="var-kms_key_name"></a>

  Customer-managed Encryption Key available through Google's Key Management Service. It must be the fully qualified resource name, i.e. projects/project-id/locations/location/keyRings/keyring/cryptoKeys/key. Cannot be updated.

#### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependencies)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:

  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`module_tags`**

  The map of tags that are being applied to all created resources that accept tags.

## External Documentation

### Google Documentation

- https://cloud.google.com/composer/docs

### Terraform AWS Provider Documentation

- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/composer_environment

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-composer
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-composer/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-composer/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-composer/issues
[license]: https://github.com/mineiros-io/terraform-google-composer/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-composer/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-composer/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-composer/blob/main/CONTRIBUTING.md
