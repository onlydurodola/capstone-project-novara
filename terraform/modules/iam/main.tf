resource "aws_iam_role" "kops_master" {
  name = "${replace(var.cluster_name, ".", "-")}-master"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "kops_master" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  ])
  role       = aws_iam_role.kops_master.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "kops_master" {
  name = "${replace(var.cluster_name, ".", "-")}-master-profile"
  role = aws_iam_role.kops_master.name
}

resource "aws_iam_role" "kops_node" {
  name = "${replace(var.cluster_name, ".", "-")}-node"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "kops_node" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ])
  role       = aws_iam_role.kops_node.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "kops_node" {
  name = "${replace(var.cluster_name, ".", "-")}-node-profile"
  role = aws_iam_role.kops_node.name
}
