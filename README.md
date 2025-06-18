# Terraform / Scaleway / Automated block storage volume snapshots

## Purpose

This module automates the creation of snapshots for Scaleway block storage volumes. Should be used in
conjuction with the [Docker image](https://github.com/keepgettingbetter/scaleway-volume-snapshot-docker).

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Follow the [instructions in the Docker image repository](https://github.com/keepgettingbetter/scaleway-volume-snapshot-docker).
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

Below a complete example of how to use this module in conjunction with the open source modules provided
by Scaleway:

```hcl
locals {
  parameters = {
    SCW_ACCESS_KEY = scaleway_iam_api_key.serverless_job_awesome_instance_backup.access_key
    SCW_SECRET_KEY = scaleway_iam_api_key.serverless_job_awesome_instance_backup.secret_key
  }
}

# Create secrets for the Scaleway access and secret keys
module "secrets_awesome_instance" {
  for_each = local.parameters
  source   = "scaleway-terraform-modules/secrets/scaleway"
  version  = "0.1.0"

  name = each.key
  path = "/infrastructure/serverless/awesome-instance-snapshot"
  data = each.value
}

# Create Container Registry Namespace
resource "scaleway_registry_namespace" "awesome" {
  name        = "my-cr"
  description = "My container registry"
  is_public   = false
}

# The snapshot module
module "volume-snapshot-awesome-instance" {
  source  = "git@github.com:my-awesome-project/scaleway-volume-snapshot-terraform.git"
  version = "0.0.1"

  name         = "awesome-instance"
  # See https://github.com/keepgettingbetter/scaleway-volume-snapshot-docker
  docker_image = "rg.nl-ams.scw.cloud/my-cr/instance-snapshot:0.0.1"
  project_id   = data.scaleway_account_project.my-awesome-project.project_id
  scw_default_organization_id = data.scaleway_account_project.my-awesome-project.organization_id
  scw_default_region = "nl-ams"
  scw_default_zone   = "nl-ams-1"
  volume_id    = "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" # Replace with your actual volume ID
  scw_access_key_secret_id = module.secrets_awesome_instance["SCW_ACCESS_KEY"].secret_id
  scw_access_key_secret_version = module.secrets_awesome_instance["SCW_ACCESS_KEY"].secret_version
  scw_secret_key_secret_id = module.secrets_awesome_instance["SCW_SECRET_KEY"].secret_id
  scw_secret_key_secret_version = module.secrets_awesome_instance["SCW_SECRET_KEY"].secret_version

  cron_snapshot = {
    schedule = "0 4 * * *"
    timezone = "Europe/Amsterdam"
  }

  cron_clean = {
    schedule = "30 4 * * *"
    timezone = "Europe/Amsterdam"
  }
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement_scaleway) | 2.55.0 |

## Resources

| Name | Type |
|------|------|
| [scaleway_job_definition.instance_snapshot_clean](https://registry.terraform.io/providers/scaleway/scaleway/2.55.0/docs/resources/job_definition) | resource |
| [scaleway_job_definition.instance_snapshot_create](https://registry.terraform.io/providers/scaleway/scaleway/2.55.0/docs/resources/job_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_docker_image"></a> [docker_image](#input_docker_image) | The Docker image URI to be used for the job definitions. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | The name to be used for the job definitions and resources. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project_id](#input_project_id) | The ID of the Scaleway project where the job definitions will be created. | `string` | n/a | yes |
| <a name="input_scw_access_key_secret_id"></a> [scw_access_key_secret_id](#input_scw_access_key_secret_id) | The secret ID of the Scaleway access key for the job definition. | `string` | n/a | yes |
| <a name="input_scw_access_key_secret_version"></a> [scw_access_key_secret_version](#input_scw_access_key_secret_version) | The secret version of the Scaleway access key for the job definition. | `string` | n/a | yes |
| <a name="input_scw_default_organization_id"></a> [scw_default_organization_id](#input_scw_default_organization_id) | SCW_DEFAULT_ORGANIZATION_ID for scw cli. | `string` | n/a | yes |
| <a name="input_scw_default_region"></a> [scw_default_region](#input_scw_default_region) | SCW_DEFAULT_REGION for scw cli. | `string` | n/a | yes |
| <a name="input_scw_default_zone"></a> [scw_default_zone](#input_scw_default_zone) | SCW_DEFAULT_ZONE for scw cli. | `string` | n/a | yes |
| <a name="input_scw_secret_key_secret_id"></a> [scw_secret_key_secret_id](#input_scw_secret_key_secret_id) | The secret ID of the Scaleway secret key for the job definition. | `string` | n/a | yes |
| <a name="input_scw_secret_key_secret_version"></a> [scw_secret_key_secret_version](#input_scw_secret_key_secret_version) | The secret version of the Scaleway secret key for the job definition. | `string` | n/a | yes |
| <a name="input_volume_id"></a> [volume_id](#input_volume_id) | The ID of the volume to be snapshot. | `string` | n/a | yes |
| <a name="input_cron_clean"></a> [cron_clean](#input_cron_clean) | Cron schedule for the job definition. If not set, the job will not be scheduled. | ```object({ schedule = string timezone = string })``` | `null` | no |
| <a name="input_cron_snapshot"></a> [cron_snapshot](#input_cron_snapshot) | Cron schedule for the job definition. If not set, the job will not be scheduled. | ```object({ schedule = string timezone = string })``` | `null` | no |
<!-- END_TF_DOCS -->
