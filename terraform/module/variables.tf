# --- ROKS ---
variable "ibmcloud_api_key" {
  description = "Enter your IBM API Cloud access key. Visit this link for more information: https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui "
}

variable "resource_group" {
  default     = "Default"
  description = "Resource group name where the cluster is hosted."
}

variable "region" {
    description = "Region where the cluster is hosted."
}

variable "cluster_config_path" {
  default     = "./.kube/config"
  description = "directory to store the kubeconfig file"
}

variable "cluster_id" {
  default     = ""
  description = "Set your cluster ID to install the Cloud Pak for Business Automation. Leave blank to provision a new OpenShift cluster."
}

# --- TURBONOMIC ---
variable "turbo_project" {
  description = "Turbonomic workspace where the operator and pods will be created."
  default     = "turbonomic"
}

variable "enable_turbonomic" {
  description = "If set to true, it will install Turbonomic on the given cluster"
  type = bool
  default = true
}

variable "turbo_server_url" {}

variable "turbo_username" {}

variable "turbo_password" {}

variable "target_name" {}

variable "regex" {}

variable "nginx_or_your_ingress" {
  description = "Starting with Turbonomic 8.3.2: set to true to use the default NGINX as a proxy, or false if you want to use your own ingress/route and still maintain the Turbonomic insterrnal roouting rules and leverage nginx as a proxy. To learn more: https://github.com/turbonomic/t8c-install/wiki/Platform-Provided-Ingress-&-OpenShift-Routes"
  default     = true
}