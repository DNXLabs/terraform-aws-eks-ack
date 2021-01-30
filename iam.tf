# Role
data "aws_iam_policy_document" "kubernetes_ack_assume" {
  count = length(var.helm_services)

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:ack-${var.helm_services[count.index].name}-controller",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "kubernetes_ack" {
  count              = length(var.helm_services)
  name               = "${var.cluster_name}-${var.helm_services[count.index].name}-ack"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_ack_assume[count.index].json
}

resource "aws_iam_role_policy_attachment" "kubernetes_ack" {
  count      = length(var.helm_services)
  role       = aws_iam_role.kubernetes_ack[count.index].name
  policy_arn = var.helm_services[count.index].policy_arn
}

# TODO - Missing sfn and ecr