# TECHMASTER - FINAL PROJECT

## Setup 1: AWS EC2 Instances

1. **Introduction**: In this section, we'll initialize some necessary AWS EC2 instances, including:
    - 1st instance: CI/CD instance for Jenkins and ArgoCD. In this scope, we'll follow the CI/CD pull-based model for
      our source code changes.
    - 2nd instance: Monitoring instance for Prometheus and Grafana which consumes metrics from the 1st instance and
      visualize those metrics through dashboards.
    - 3rd instance: Kubernetes instance for running pods, deployments, or applications. Our K8S cluster will have only
      one node now.

2. **Commands**:
   ```
   cd terraform
   
   // Export crucial AWS secrets through "Security Credentials - Access Keys" feature.
   export AWS_ACCESS_KEY_ID=
   export AWS_SECRET_ACCESS_KEY=
   
   // Format all Terraform files.
   terraform fmt -recursive
   
   // Initialize Terraform requirements and prerequisites.
   terraform init
   
   // Validate Terraform logic.
   terraform validate
   
   // Show all expected Terraform changes before oficially applying them.
   terraform plan --var-file=./terraform.tfvars
   
   // Official apply all Terraform changes with an auto approval.
   terraform apply -auto-approve --var-file=./terraform.tfvars
   
   // If we have made any changes in the real-world infrastructure (e.g directly changing something in AWS EC2 website),
   // then we should use this command to refresh the correct and latest system states. 
   terraform refresh --var-file=./terraform.tfvars
   
   // Show all expected Terraform changes before oficially destroying them.
   terraform plan -destroy --var-file=./terraform.tfvars
   
   // Destroy all Terraform resources (EC2, SecurityGroup, NetworkInterfaces, etc).
   // We should run this command at the last stage of development to delete all resources.
   terraform destroy --var-file=./terraform.tfvars
   ```

3. **Notes**:
   - 1st EC2 instance for CI/CD services:
     - Jenkins port: **8080**
     - CAdvisor port: **8081**
     - Prometheus Node Exporter port: **9100**
     - ArgoCD Server UI port: **9080**
     - ArgoCD Metrics port: **9082**
     - ArgoCD Server Metrics port: **9083**
     - ArgoCD Repo Server Metrics port: **9084**
   - 2nd EC2 instance for monitoring services:
     - Prometheus port: **9090**
     - Grafana port: **3000**
   - 3rd EC2 instance for K8S services:
     - Prometheus Node Exporter port: **9100**
     - Please follow with other K8S service ports in next steps.

## Setup 2: Github & Docker Registry

- To be defined later.

