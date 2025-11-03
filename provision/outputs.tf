output "cluster_summary" {
  description = "Cluster summary"
  value = {
    region    = var.region
    masters   = local.all_masters
    workers   = local.workers
  }
}