module "test" {
  source = "../.."

  # add all required arguments

  name = "unit-complete-${local.random_suffix}"

  software_config = {
    python_version = 3
  }

  # add all optional arguments that create additional/extended resources
  maintenance_window = {
    start_time = "2021-01-01T09:00:00Z"
    end_time   = "2021-01-01T11:00:00Z"
    recurrence = "FREQ=WEEKLY;BYDAY=WE,TH,SU"
  }

  # add most/all other optional arguments

}
