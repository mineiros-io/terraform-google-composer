module "test" {
  source = "../.."

  # add all required arguments

  name = "unit-complete-${local.random_suffix}"

  software_config = {
    python_version = 3
  }

  # add all optional arguments that create additional/extended resources

  # add most/all other optional arguments

}
