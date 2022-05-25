locals {
  namespace_file_content = templatefile("${path.module}/templates/namespace.yaml.tmpl", {
    NAMESPACE = var.turbo_project
  } )

  service_account_file_content = templatefile("${path.module}/templates/service_account.yaml.tmpl", {
    NAMESPACE = var.turbo_project
  } )

  role_binding_file_content = templatefile("${path.module}/templates/role_binding_admin.yaml.tmpl", {
    NAMESPACE = var.turbo_project
  } )

  configmap_file_content = templatefile("${path.module}/templates/configmap.yaml.tmpl", {
    NAMESPACE        = var.turbo_project
    TURBO_SERVER_URL = var.turbo_server_url
    TURBO_USERNAME   = var.turbo_username
    TURBO_PASSWORD   = var.turbo_password
    TARGET_NAME      = var.target_name
    REGREX           = var.regex
  } )

  kubeturbo_deploy_file_content = templatefile("${path.module}/templates/kubeturbo_deploy.yaml.tmpl", {
    NAMESPACE = var.turbo_project
  } )

  operator_group_file_content = templatefile("${path.module}/templates/operator_group.yaml.tmpl", {
    NAMESPACE = var.turbo_project
  } )

  subscription_file_content = templatefile("${path.module}/templates/subcription.yaml.tmpl", {
    NAMESPACE = var.turbo_project
  } )

  nginx_ingress_file_content = templatefile("${path.module}/templates/nginx_ingress.yaml.tmpl", {
    NGINX_INGRESS = var.nginx_or_your_ingress
  } )
}


resource "null_resource" "install_turbonomic" {
  count = var.enable_turbonomic ? 1 : 0

  triggers = {
    KUBECONFIG                  = var.cluster_config_path
    TURBO_PROJECT               = var.turbo_project
    NAMESPACE_FILE_CONTENT_sha1 = sha1(local.namespace_file_content)
    SERVICE_ACCOUNT_FILE_CONTENT_sha1 = sha1(local.service_account_file_content)
    CONFIGMAP_FILE_CONTENT_sha1       = sha1(local.configmap_file_content)
    OPERATOR_GROUP_FILE_CONTENT_sha1  = sha1(local.operator_group_file_content)
    SUBSCRIPTION_FILE_CONTENT_sha1    = sha1(local.subscription_file_content)
    NGINX_INGRESS_FILE_CONTENT_sha1   = sha1(local.nginx_ingress_file_content)
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/install_turbonomic.sh"

    environment = {
      KUBECONFIG    = var.cluster_config_path
      TURBO_PROJECT = var.turbo_project

      # --- Files
      NAMESPACE_FILE_CONTENT        = local.namespace_file_content
      SERVICE_ACCOUNT_FILE_CONTENT  = local.service_account_file_content
      ROLE_BINDING_FILE_CONTENT     = local.role_binding_file_content
      CONFIGMAP_FILE_CONTENT        = local.configmap_file_content
      KUBETURBO_DEPLOY_FILE_CONTENT = local.kubeturbo_deploy_file_content
      OPERATOR_GROUP_FILE_CONTENT   = local.operator_group_file_content
      SUBSCRIPTION_FILE_CONTENT     = local.subscription_file_content
      NGINX_INGRESS_FILE_CONTENT    = local.nginx_ingress_file_content
    }
  }
}
