module "test" {
  source = "../.."

  # add only required arguments and no optional arguments

  name = "unit-minimal-${local.random_suffix}"

  software_config = {
    python_version = 3
  }
}
