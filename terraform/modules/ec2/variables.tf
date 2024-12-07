variable "security_group_ids" {
  description = "List of security group IDs to attach to the EC2 instance."
  type        = list(string)
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the EC2-sg resources"
}

variable "region" {
  type        = string
  description = "Region of the EC2 instance"
}

variable "ami_id" {
  type        = string
  description = "AMI ID of the EC2 instance"
}

variable "key_name" {
  type        = string
  description = "Key name of the EC2 instance (EC2 Key Pairs)"
}

variable "instance_type" {
  type        = string
  description = "Instance type of the EC2 instance"
}

variable "instance_count" {
  type        = number
  description = "Count of the EC2 instances"
}

variable "volume_size" {
  type        = number
  description = "AWS EC2 volume size in GB"
}

variable "volume_type" {
  type        = string
  description = "AWS EC2 volume type"
}

variable "name" {
  type        = string
  description = "The name of the resources."
}

variable "prefix" {
  type        = string
  description = "The prefix in name for the resources."
}

variable "environment" {
  type        = string
  description = "The environment name for the resources."
}

variable "application" {
  type        = string
  description = "Name of the application related to the resource."
}

