subscription_id = "########-####-####-####-############"
location        = "australiaEast"
naming = {
  org_code      = "lat"
  env_code      = "dev"
  loc_code      = "aue"
  wrk_code      = "tflab"
  lucky_numbers = [15, 03, 2024]
}
web_app = {
  web_apps = [
    {
      name = "default-latrrrtest"
    },
    {
      name              = "fancy-container-latrrrtest"
      docker_image_name = "ryanroyals/helloworldenv:latest"
    },
    {
      name              = "even-fancier-container-latrrrtest"
      docker_image_name = "ryanroyals/helloworldenv:latest"
      app_settings = {
        "swish_status" = "super_duper_swish"
      }
    }
  ]
}
count_storage = 3