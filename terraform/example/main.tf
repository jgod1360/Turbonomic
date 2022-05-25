provider "ibm" {
  region           = var.region
  ibmcloud_api_key = var.ibmcloud_api_key
}

data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "null_resource" "mkdir_kubeconfig_dir" {
  triggers = { always_run = timestamp() }

  provisioner "local-exec" {
    command = "mkdir -p ${var.cluster_config_path}"
  }
}

data "ibm_container_cluster_config" "cluster_config" {
  depends_on        = [null_resource.mkdir_kubeconfig_dir]
  cluster_name_id   = var.cluster_id
  resource_group_id = data.ibm_resource_group.resource_group.id
  config_dir        = var.cluster_config_path
  download          = true
}

module "install_turbonomic" {
  source = "../module"
  enable_turbonomic   = var.enable_turbonomic

  ibmcloud_api_key    = var.ibmcloud_api_key
  region              = var.region
  resource_group      = var.resource_group
  cluster_id          = var.cluster_id
  cluster_config_path = var.cluster_config_path
  turbo_project       = var.turbo_project
  turbo_server_url    = var.turbo_server_url
  turbo_username      = var.turbo_username
  turbo_password      = var.turbo_password
  target_name         = var.target_name
  regex              = var.regex
  nginx_or_your_ingress = var.nginx_or_your_ingress
}