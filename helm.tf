
resource "helm_release" "ack" {
  depends_on        = [var.mod_dependency]
  count             = var.enabled ? length(var.helm_services) : 0
  name              = "ack-${var.helm_services[count.index].name}-controller"
  repository        = "oci://public.ecr.aws/aws-controllers-k8s"
  chart             = "${var.helm_services[count.index].name}-chart"
  namespace         = var.namespace
  create_namespace  = var.create_namespace
  version           = var.helm_services[count.index].version

  set {
    name            = "aws.region"
    value           = var.aws_region
  }

  set {
    name            = "serviceAccount.name"
    value           = "ack-${var.helm_services[count.index].name}-controller"
  }

  set {
    name            = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value           = aws_iam_role.kubernetes_ack[count.index].arn
  }

  values            = [
    yamlencode(var.settings)
  ]

}
