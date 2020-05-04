variable "name" {
  type = string
  description = "Kubernetes Cluster Name"
}

variable "rancher_url" {
  type = string
  description = "The Rancher URL"
}

variable "rancher_access_key" {
  type = string
  description = "The Rancher Access Key"
}

variable "rancher_secret_key" {
  type = string
  description = "The Rancher Secret Key"
}

variable "vcenter_server" {
  type = string
  description = "vCenter Server Address"
}

variable "vcenter_username" {
  type = string
  description = "vCenter Username"
}

variable "vcenter_password" {
  type = string
  description = "vCenter Password"
}

variable "vcenter_port" {
  type = string
  description = "vCenter Port"
  default = 443
}


variable "vcenter_datacenter" {
  type = string
  description = "vCenter Datacenter"
}

variable "vcenter_datastore" {
  type = string
  description = "vCenter Datastore where Kubernetes nodes store to"
}

variable "vcenter_resourcepool" {
  type = string
  description = "vCenter ResourcePool where Kubernetes nodes work on "
}

variable "vcenter_folder" {
  type = string
  description = "vCenter Folder where Kubernetes nodes in"
}

variable "vcenter_network" {
  type = list
  description = "The Kubernetes nodes network"
  default = ["VM Network"]
}

variable "master_cpu" {
  type = string
  description = "The Kubernetes master CPU count"
  default = 4
}

variable "master_memory" {
  type = string
  description = "The Kubernetes master memory"
  default = 4096
}

variable "master_disk" {
  type = string
  description = "The Kubernetes master disk size"
  default = 40960
}

variable "master_count" {
  type = string
  description = "The number of master node"
  default = 3
}

variable "worker_cpu" {
  type = string
  description = "The Kubernetes worker CPU count"
  default = 8
}

variable "worker_memory" {
  type = string
  description = "The Kubernetes worker memory"
  default = 8192
}

variable "worker_disk" {
  type = string
  description = "The Kubernetes worker disk size"
  default = 40960
}

variable "worker_count" {
  type = string
  description = "The number of worker node"
  default = 3
}

variable "docker_registry_mirror" {
  type = list
  description = "The docker registry mirror"
  default = []
}

variable "boot2docker_url" {
  type = string
  description = "The RancherOS image URL"
  default = "https://releases.rancher.com/os/latest/rancheros-vmware.iso"
}
