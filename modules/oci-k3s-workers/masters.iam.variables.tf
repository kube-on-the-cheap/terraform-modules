variable "k3s_bucket_names" {
  type        = set(string)
  description = "The Object Storage bucket names used by the cluster"
  default     = []
}
