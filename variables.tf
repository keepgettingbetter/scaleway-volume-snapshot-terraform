variable "name" {
    description = "The name to be used for the job definitions and resources."
    type        = string
}

variable "docker_image" {
    description = "The Docker image URI to be used for the job definitions."
    type        = string
}

variable "project_id" {
    description = "The ID of the Scaleway project where the job definitions will be created."
    type        = string
}

variable "scw_default_organization_id" {
    description = "SCW_DEFAULT_ORGANIZATION_ID for scw cli."
    type        = string
}

variable "scw_default_region" {
    description = "SCW_DEFAULT_REGION for scw cli."
    type        = string
}

variable "scw_default_zone" {
    description = "SCW_DEFAULT_ZONE for scw cli."
    type        = string
}

variable "volume_id" {
    description = "The ID of the volume to be snapshot."
    type        = string
}

variable "scw_access_key_secret_id" {
    description = "The secret ID of the Scaleway access key for the job definition."
    type        = string
}

variable "scw_access_key_secret_version" {
    description = "The secret version of the Scaleway access key for the job definition."
    type        = string
}

variable "scw_secret_key_secret_id" {
    description = "The secret ID of the Scaleway secret key for the job definition."
    type        = string
}

variable "scw_secret_key_secret_version" {
    description = "The secret version of the Scaleway secret key for the job definition."
    type        = string
}

variable "cron_clean" {
    description = "Cron schedule for the job definition. If not set, the job will not be scheduled."
    type        = object({
        schedule = string
        timezone = string
    })
    default     = null
}

variable "cron_snapshot" {
    description = "Cron schedule for the job definition. If not set, the job will not be scheduled."
    type        = object({
        schedule = string
        timezone = string
    })
    default     = null
}
