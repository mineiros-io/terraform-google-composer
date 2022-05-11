variable "name" {
  type        = string
  description = "(Required) Name of the composer environment"
}

variable "project" {
  type        = string
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  default     = null
}

variable "region" {
  type        = string
  description = "(Optional) The location or Compute Engine region for the environment."
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "(Optional) User-defined labels for this environment. The labels map can contain no more than 64 entries."
  default     = {}
}

variable "node_count" {
  type        = number
  description = "(Optional) The number of nodes in the Kubernetes Engine cluster that will be used to run this environment."
  default     = null
}

variable "software_config" {
  type        = any
  description = "(Optional) The configuration settings for software inside the environment."
  default     = null
}

variable "private_environment_config" {
  type        = any
  description = "(Optional) The configuration used for the Private IP Cloud Composer environment."
  default     = null
}

variable "database_machine_type" {
  type        = string
  description = "(Optional) Cloud SQL machine type used by Airflow database. It has to be one of: db-n1-standard-2, db-n1-standard-4, db-n1-standard-8 or db-n1-standard-16."
  default     = null
}

variable "webserver_machine_type" {
  type        = string
  description = "(Optional) Machine type on which Airflow web server is running. It has to be one of: composer-n1-webserver-2, composer-n1-webserver-4 or composer-n1-webserver-8."
  default     = null
}

variable "web_server_allowed_ip_ranges" {
  type        = any
  description = "(Optional) A collection of allowed IP ranges with descriptions."
  default     = null
}

variable "node_config" {
  type        = any
  description = "(Optional) The configuration used for the Kubernetes Engine cluster."
  default     = null
}

variable "kms_key_name" {
  type        = string
  description = "(Optional) Customer-managed Encryption Key available through Google's Key Management Service. It must be the fully qualified resource name, i.e. projects/project-id/locations/location/keyRings/keyring/cryptoKeys/key. Cannot be updated."
  default     = null
}

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether resources in thismodule should be created."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
