variable "function_name" {}
variable "description" {
  default = "Security group scanner"
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
variable "finder" {
  default = {}
}
variable "tags" {
  default = {}
}