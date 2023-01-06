# Role
data "aws_iam_policy_document" "kubernetes_ack_assume" {
  count = var.enabled ? length(var.helm_services) : 0

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
  count              = var.enabled ? length(var.helm_services) : 0
  name               = "${var.cluster_name}-ack-${var.helm_services[count.index].name}"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_ack_assume[count.index].json
}

resource "aws_iam_role_policy_attachment" "kubernetes_ack" {
  count      = var.enabled ? length(var.helm_services) : 0
  role       = aws_iam_role.kubernetes_ack[count.index].name
  # If there is not a default policy given, we can assume that there is a FullAccess IAM Policy for each service
  # Title will kinda work here on single word services but won't fix dynamodb to DynamoDB
  policy_arn = coalesce(var.helm_services[count.index].policy_arn, "arn:${var.aws_partition}:iam::aws:policy/Amazon${title(var.helm_services[count.index].name)}FullAccess")
}


# TODO - Missing sfn and ecr
