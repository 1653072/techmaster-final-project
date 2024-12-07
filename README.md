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
    terraform validate
    terraform init
    terraform plan --var-file=./terraform.tfvars
    terraform apply --var-file=./terraform.tfvars
    terraform destroy --var-file=./terraform.tfvars
    ```

## Setup 2: Github & Docker Registry


