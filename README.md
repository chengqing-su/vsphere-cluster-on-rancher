# Create a vSphere cluster on Rancher

This a repo to help you create a vSphere cluster on Rancher.

## Prerequisites
1. vSphere vCenter is ready.
2. A resource pool and a vm/vm-template folder are provisioned.
3. A rancher is ready.

## How to create

1. Copy the below content to a new file `terraform/terraform.tfvars`
```
name = "<YOUR-CLUSTER-NAME>"
rancher_url = "<YOUR-RANCHER-URL>"
rancher_access_key = "<YOUR-RANCHER-ACCESS-KEY>"
rancher_secret_key = "<YOUR-RANCHER-SECRET-KEY>"

vcenter_server = "<YOUR-VCENTER-IP-OR-DOMAIN>"
vcenter_username = "<YOUR-VCENTER-USERNAME>"
vcenter_password = "<YOUR-VCENTER-PASSWORD>"
vcenter_datacenter = "<YOUR-VCENTER-DATACENTER>" #absolute path, like /datacenter
vcenter_datastore = "<YOUR-VCENTER-DATASTORE>" #absolute path, like /<your-datacenter-name>/datastore/<your-datastore-name>"
vcenter_folder = "<YOUR-VCENTER-VM-FOLDER>" #absolute path, like /<your-datacenter-name>/vm/<your-vm-folder>"
vcenter_resourcepool = "<YOUR-VCENTER-RESOURCE-POOL>" # absolute path, like /<your-datacenter-name>/host/<your-cluster-name>/Resources/<your-resource-pool>

# If your are in China, the below configuration will help you pull docker images and setup node faster than before.
docker_registry_mirror = ["xxx..mirror.aliyuncs.com"]
boot2docker_url = "YOUR-OS-URL"
```

2. Run command `auto/init` to init terraform.

3. Run command `auto/apply` to apply terraform files to Rancher.

## Create a vSphere storage class

Here is a manifest to create a vSphere storage class.

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  name: vsphere
parameters:
  datastore: <YOUR-DATASTORE>
  diskformat: thin
provisioner: kubernetes.io/vsphere-volume
```
