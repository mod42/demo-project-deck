variable "ee_license" {
  description = "Enterprise Edition license key (JSON format)"
  type        = any

  default = { "license": { "version": 1, "signature": "d63f5f8e38006cd61ef7d82747e99e30616869dd08af28df0682cd86fc4dfb1dd655880a526eb1585401d653c4dbe188fa2d8e13d8165a47eab0f10063e55e9a", "payload": { "customer": "Kong Inc. SEs", "license_creation_date": "2022-05-18", "product_subscription": "Kong Enterprise Subscription", "support_plan": "Platinum", "admin_seats": "1", "dataplanes": "1000", "license_expiration_date": "2023-06-30", "license_key": "0011K000022IA3HQAW_a1V1K000007KlJMUA0" } }}
}

# Kong packages
variable "ee_pkg" {
  description = "Filename of the Enterprise Edition package"
  type        = string

  default = "kong-enterprise-edition_3.1.1.2_amd64.deb"
}

variable "service" {
  description = "Resource service tag"
  type        = string

  default = "kong"
}

variable "environment" {
  description = "Resource environment tag (i.e. dev, stage, prod)"
  type        = string

  default = "dev"
}

variable "pgpassword" {
  description = "Resource environment tag (i.e. dev, stage, prod)"
  type        = string

  default = "kong"
}

variable "db_host" {
  description = "Resource environment tag (i.e. dev, stage, prod)"
  type        = string

  default = "localhost"
}

variable "db_name" {
  description = "Resource environment tag (i.e. dev, stage, prod)"
  type        = string

  default = "kong"
}

variable "db_password" {
  description = "Resource environment tag (i.e. dev, stage, prod)"
  type        = string

  default = "kong"
}

variable "manager_host" {
  description = "Hostname to access Kong Manager (Enterprise Edition only)"
  type        = string

  default = "default"
}

variable "portal_host" {
  description = "Hostname to access Portal (Enterprise Edition only)"
  type        = string

  default = "default"
}

variable "deck_version" {
  description = "Hostname to access Portal (Enterprise Edition only)"
  type        = string

  default = "1.17.2"
}

variable "ce_pkg" {
  description = "Filename of the Community Edition package"
  type        = string

  default = "kong_2.8.1_amd64.deb"
}