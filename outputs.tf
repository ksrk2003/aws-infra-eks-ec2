output "ec2_public_ip" {
  description = "Public IP of Ubuntu EC2 instance"
  value       = aws_instance.ubuntu.public_ip
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = module.eks.cluster_endpoint
}
