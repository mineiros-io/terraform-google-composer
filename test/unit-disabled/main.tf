module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments

  name = "unit-disabled"

  software_config = {
    python_version = 3
  }

  # add all optional arguments that create additional/extended resources
}
