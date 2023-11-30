variable "ampere_a1_allocation_schema" {
  type = map(number)
  validation {
    condition     = length([for class, count in var.ampere_a1_allocation_schema : class if contains(["wood", "copper", "silver", "gold", "platinum", "diamond"], class)]) == length(keys(var.ampere_a1_allocation_schema))
    error_message = "Please specify one of \"wood\", \"copper\", \"silver\", \"gold\", \"platinum\" or \"diamond\" as keys."
  }
  # TODO: count should be at least 1
  # validation {
  #   condition     = length([for class, params in var.ampere_a1_allocation_schema : class if contains(["wood", "copper", "silver", "gold", "platinum", "diamond"], class)]) > 0
  #   error_message = "Your map must describe at least one of the four tiers."
  # }
  # validation {
  #   condition = setsubtract([for class, params in var.ampere_a1_allocation_schema : [
  #     for item in params : item if contains(["master", "worker"], item.role) && item.count > 0
  #   ]], values(var.ampere_a1_allocation_schema)) == []
  #   error_message = "Please include only positive count values and \"master\" or \"worker\" types."
  # }
  description = "The resource allocation schema for flexible Ampere A1 instances"
}
