
module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "18.2.6"
  cluster_name                    = local.cluster_name
  cluster_endpoint_private_access = true
  cluster_version                 = "1.20"
  subnet_ids                      = module.vpc.private_subnets

  vpc_id                      = module.vpc.vpc_id
  create_cloudwatch_log_group = false

  eks_managed_node_group_defaults = {
    instance_types = ["t2.small"]
  }

  eks_managed_node_groups = {
    group1 = {
      min_size       = 1
      max_size       = 10
      desired_size   = 2
      instance_types = ["t3.large"]
      tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "owned"
      }
    }
  }

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}
