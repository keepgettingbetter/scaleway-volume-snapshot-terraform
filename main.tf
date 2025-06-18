resource "scaleway_job_definition" "instance_snapshot_create" {
  name         = "instance-snapshot-create-${var.name}"
  cpu_limit    = 140
  command       = "/app/snapshot-create.sh"
  memory_limit = 256
  # see https://github.com/keepgettingbetter/scaleway-volume-snapshot-docker
  image_uri    = var.docker_image
  timeout      = "2m"
  project_id   = var.project_id

  dynamic "cron" {
    for_each = var.cron_snapshot != null ? [var.cron_snapshot] : []
    content {
      schedule = cron.value.schedule
      timezone = cron.value.timezone
    }
  }

  env = {
    "SCW_DEFAULT_ORGANIZATION_ID" : var.scw_default_organization_id,
    "SCW_DEFAULT_PROJECT_ID" : var.project_id,
    "SCW_DEFAULT_REGION" : var.scw_default_region,
    "SCW_DEFAULT_ZONE" : "nl-ams-1",
    "SNAPSHOT_NAME_PREFIX": var.name,
    "SNAPSHOT_TAG": "name=${var.name}",
    "VOLUME_ID": var.volume_id
  }

  secret_reference {
    secret_id      = var.scw_access_key_secret_id
    secret_version = var.scw_access_key_secret_version
    environment    = "SCW_ACCESS_KEY"
  }
  secret_reference {
    secret_id      = var.scw_secret_key_secret_id
    secret_version = var.scw_secret_key_secret_version
    environment    = "SCW_SECRET_KEY"
  }
}

resource "scaleway_job_definition" "instance_snapshot_clean" {
  name         = "instance-snapshot-clean-${var.name}"
  cpu_limit    = 140
  memory_limit = 256
  image_uri    = var.docker_image
  timeout      = "2m"

  dynamic "cron" {
    for_each = var.cron_clean != null ? [var.cron_clean] : []
    content {
      schedule = cron.value.schedule
      timezone = cron.value.timezone
    }
  }

  env = {
    "SCW_DEFAULT_ORGANIZATION_ID" : var.scw_default_organization_id,
    "SCW_DEFAULT_PROJECT_ID" : var.project_id,
    "SCW_DEFAULT_REGION" : var.scw_default_region,
    "SCW_DEFAULT_ZONE" : "nl-ams-1",
    "SNAPSHOTS_TO_KEEP": "10",
    "SNAPSHOT_TAG": "name=${var.name}",
  }

  secret_reference {
    secret_id      = var.scw_access_key_secret_id
    secret_version = var.scw_access_key_secret_version
    environment    = "SCW_ACCESS_KEY"
  }
  secret_reference {
    secret_id      = var.scw_secret_key_secret_id
    secret_version = var.scw_secret_key_secret_version
    environment    = "SCW_SECRET_KEY"
  }
}
