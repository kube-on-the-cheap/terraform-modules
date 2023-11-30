variable "cloud_init_config" {
  description = "The init.cfg templated file content"
  type        = string
}

variable "cloud_init_script" {
  description = "The init.cfg templated file content"
  type        = string
}

variable "k3s_tags" {
  type        = map(string)
  description = "A map of defined tags to apply"
}
