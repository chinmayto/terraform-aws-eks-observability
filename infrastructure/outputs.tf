output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "vpc_id" {
  description = "ID of the VPC where the cluster is deployed"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

################################################################################
# Monitoring Outputs
################################################################################
output "prometheus_service_info" {
  description = "Prometheus service information"
  value = {
    namespace    = kubernetes_namespace.monitoring.metadata[0].name
    service_name = "prometheus-kube-prometheus-prometheus"
  }
}

output "grafana_service_info" {
  description = "Grafana service information"
  value = {
    namespace      = kubernetes_namespace.monitoring.metadata[0].name
    service_name   = "prometheus-grafana"
    admin_password = "admin123"
  }
}

output "monitoring_access_commands" {
  description = "Commands to access monitoring services"
  value = {
    prometheus_url          = "http://prometheus.chinmayto.com"
    grafana_url             = "http://grafana.chinmayto.com"
    prometheus_port_forward = "kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090"
    grafana_port_forward    = "kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80"
    get_nginx_loadbalancer  = "kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
    check_ingress_status    = "kubectl get ingress -n monitoring"
  }
}