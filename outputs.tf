output "vpc_security_group"{
    value = module.vpc
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_repository_url" {
    value = aws_ecr_repository.main_repository.repository_url 
}