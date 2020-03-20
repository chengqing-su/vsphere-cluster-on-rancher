provider "rancher2" {
  api_url    = var.rancher_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}

resource "rancher2_cloud_credential" "vsphere" {
  name = "vsphere-vcenter"
  description = "vsphere credential"
  vsphere_credential_config{
      username = var.vcenter_username
      password = var.vcenter_password
      vcenter = var.vcenter_server
      vcenter_port = var.vcenter_port
  }
}

resource "rancher2_node_template" "vsphere_k8s_master" {
    name = "vsphere_k8s_master"
    cloud_credential_id = rancher2_cloud_credential.vsphere.id
    vsphere_config{
        cpu_count = var.master_cpu
        memory_size = var.master_memory
        disk_size = var.master_disk
        datacenter = var.vcenter_datacenter
        datastore = var.vcenter_datastore
        folder = var.vcenter_folder
        network = var.vcenter_network
        cfgparam = ["disk.enableUUID=TRUE"]
    }
}

resource "rancher2_node_template" "vsphere_k8s_node" {
    name = "vsphere_k8s_node"
    cloud_credential_id = rancher2_cloud_credential.vsphere.id
    vsphere_config{
        cpu_count = var.worker_cpu
        memory_size = var.worker_memory
        disk_size = var.worker_disk
        datacenter = var.vcenter_datacenter
        datastore = var.vcenter_datastore
        folder = var.vcenter_folder
        network = var.vcenter_network
        cfgparam = ["disk.enableUUID=TRUE"]
    }
}

resource "rancher2_cluster" "cluster" {
  name = var.name
  rke_config {
    network {
      plugin = "canal"
    }
    cloud_provider{
        name = "vsphere"
        vsphere_cloud_provider {
            virtual_center{
                name = var.vcenter_server
                password = var.vcenter_password
                user = var.vcenter_username
                port = var.vcenter_port
                datacenters = var.vcenter_datacenter
            }
            workspace{
                datacenter = var.vcenter_datacenter
                default_datastore = var.vcenter_datastore
                folder = var.vcenter_folder
                resourcepool_path = var.vcenter_resourcepool
                server = var.vcenter_server
            }
            global{
                insecure_flag = true
            }
        }
    }

  }
  enable_cluster_monitoring = true
  cluster_monitoring_input {
    answers = {
      "exporter-kubelets.https" = true
      "exporter-node.enabled" = true
      "exporter-node.ports.metrics.port" = 9796
      "exporter-node.resources.limits.cpu" = "200m"
      "exporter-node.resources.limits.memory" = "200Mi"
      "grafana.persistence.enabled" = false
      "grafana.persistence.size" = "10Gi"
      "grafana.persistence.storageClass" = "default"
      "operator.resources.limits.memory" = "500Mi"
      "prometheus.persistence.enabled" = "false"
      "prometheus.persistence.size" = "50Gi"
      "prometheus.persistence.storageClass" = "default"
      "prometheus.persistent.useReleaseName" = "true"
      "prometheus.resources.core.limits.cpu" = "1000m",
      "prometheus.resources.core.limits.memory" = "1500Mi"
      "prometheus.resources.core.requests.cpu" = "750m"
      "prometheus.resources.core.requests.memory" = "750Mi"
      "prometheus.retention" = "12h"
    }
  }
}

resource "rancher2_node_pool" "master_pool" {
  cluster_id =  rancher2_cluster.cluster.id
  name = "master"
  hostname_prefix =  "${rancher2_cluster.cluster.name}-master-"
  node_template_id = rancher2_node_template.vsphere_k8s_master.id
  quantity = var.master_count
  control_plane = true
  etcd = true
  worker = false
}

resource "rancher2_node_pool" "worker_pool" {
  cluster_id =  rancher2_cluster.cluster.id
  name = "worker"
  hostname_prefix =  "${rancher2_cluster.cluster.name}-worker-"
  node_template_id = rancher2_node_template.vsphere_k8s_node.id
  quantity = var.worker_count
  control_plane = false
  etcd = false
  worker = true
}