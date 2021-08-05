variable "function_name" {}
variable "description" {
  default = ""
}
variable "environment_variables" {
  default = null
}
variable "schedule_expression" {
  default = "cron(0 0 * * ? *)"
}
variable "role" {
  default = null
}
variable "tags" {
  default = {}
}