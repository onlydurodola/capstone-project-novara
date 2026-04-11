output "master_instance_profile" { value = aws_iam_instance_profile.kops_master.name }
output "node_instance_profile"   { value = aws_iam_instance_profile.kops_node.name }
