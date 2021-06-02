resource "helm_release" "ack" {
  depends_on = [var.mod_dependency, kubernetes_namespace.ack]
  count      = var.enabled ? length(var.helm_services) : 0
  name       = "ack-${var.helm_services[count.index].name}-controller"
  chart      = "${path.module}/charts/ack-${var.helm_services[count.index].name}-controller"
  namespace  = var.namespace

  set {
    name  = "aws.region"
    value = var.aws_region
  }

  set {
    name  = "serviceAccount.name"
    value = "ack-${var.helm_services[count.index].name}-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.kubernetes_ack[count.index].arn
  }

  values = [
    yamlencode(var.settings)
  ]

}
