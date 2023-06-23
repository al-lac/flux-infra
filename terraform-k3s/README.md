# Install k3s with flux on aws

With this terraform plan you can install k3s with flux on an aws ec2 instance.

Clone this repository, replace all "your" strings with **your** data and then you can already go ahead and apply the plan.

```bash
git clone https://github.com/al-lac/flux-infra.git

cd flux-infra/terraform

# Replace all "your" strings in setup.sh and aws.tf with your data

# Initialize terraform
terraform init

# Plan and apply
terraform plan
terraform apply

# You should get an output that shows the ec2 public ip
ec2_global_ips = "10.207.220.12"

ssh rocky@10.207.220.12

sudo su -

kubectl get nodes
NAME    STATUS   ROLES                  AGE   VERSION
k3s     Ready    control-plane,master   2h   v1.26.5+k3s1
```
