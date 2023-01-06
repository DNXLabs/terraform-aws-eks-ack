variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "aws_region" {
  type        = string
  description = "AWS region where services are stored."
}

variable "aws_partition" {
  type        = string
  description = "AWS Partition where services are stored."
  default     = "aws"
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account."
}

variable "helm_services" {
  type = list(object({
    name       = string
    # Version is required to pull from public.ecr.aws. You can find the release in the specific repository in https://github.com/aws-controllers-k8s/
    version    = string
    policy_arn = optional(string)
    settings   = optional(map(any))
  }))
  default = [
    {
      name       = "s3"
      version    = "v0.1.6"
      policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
      settings   = {}
    }
  ]
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "ack-system"
  description = "Kubernetes namespace to deploy ACK Helm chart."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}
