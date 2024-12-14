# TECHMASTER - FINAL PROJECT

## Setup 1: AWS EC2 Instances

1. **Introduction**: In this section, we'll initialize some necessary AWS EC2 instances, including:
    - 1st instance: CI/CD instance for Jenkins and ArgoCD. In this scope, we'll follow the CI/CD pull-based model for
      our source code changes.
    - 2nd instance: Monitoring instance for Prometheus and Grafana which consumes metrics from the 1st instance and
      visualize those metrics through dashboards.
    - 3rd instance: Kubernetes instance for running pods, deployments, or applications. Our K8S cluster will have only
      one node now. In this instance, the Terraform K8S script also creates 2 new namespaces for us, including `dev`
      and `prd`.

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

3. **Public ports**:
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

## Setup 2: Docker Hub Registry, GitHub & Jenkins Configurations

1. **Docker Registry**:
    - Our applications will produce a new Docker Container Image for every code change. Therefore, we should prepare a
      new [Docker Hub Registry](https://hub.docker.com/) account to store these images in distinct tag versions.
    - In this final project, we can deploy new images and repositories to the Docker Hub with the public visibility.
      However, for enterprise projects, we should have our own private place to store these ones.
    - Here is my Docker Hub account for the final project:
    ```
    DOCKER_REGISTRY_USERNAME=quoctran08
    DOCKER_REGISTRY_PASSWORD=<docker_hub_account_password>
    ```

2. **GitHub Repositories & Configurations**:
    - Repositories:
        - Source code repository: ...TBD...
        - K8S manifest repository: ...TBD...
    - Configurations:
        - Inside the source code repository, we need to enable GitHub Webhook for our Jenkins.
          ```
          Instruction: Source code repository -> Settings -> Webhooks
          Payload URL: https://<jenkins_server>/github-webhook/
          Content type: application/json
          SSL verification: Disable
          Events: Just the push event
          ```
        - We need to record the GitHub username for Jenkins access permission. Here is my GitHub username for the final
          project:
          ```
          GITHUB_USERNAME=1653072
          ```
        - In GitHub settings, we also need to generate a new personal access token for Jenkins access permission.
          ```
          Instruction: 
          - Access this URL: https://github.com/settings/tokens/new
          - Add this note "Techmaster|DevOps|Jenkins|FinalProject". 
          - Change Expiration to "No expiration".
          - In the scopes section, we will select the whole "repo" scope and the "user:email" field in the "user" scope.
          ```

3. **Jenkins Plugins**: We should install these necessary Jenkins plugins to easily support our in system operation.
    ```
    Instruction: Jenkins Dashboard -> Manage Jenkins -> Manage Plugins -> Available tab.
    Plugins:
    1. Blue Ocean: Have a better visualization of pipelines, builds and deployments.
    2. Pipeline Utility Steps: Provide utility steps for pipeline jobs.
    3. Kubernetes CLI: Integrate K8S CLI with necessary commands to Jenkins.
    ```

4. **Jenkins Credentials**: We need to add crucial credentials to Jenkins, which helps it have ability to deploy new
   images to Docker Hub and new changes to GitHub.
    ```
    Instruction: Jenkins Dashboard -> Manage Jenkins -> Manage Credentials -> Global (or create a new folder) -> Add Credentials
    Crucial credentials:
    1. Docker Registry Username:
        - Kind: Secret text
        - ID: DOCKER_REGISTRY_USERNAME
        - Secret: quoctran08
    2. Docker Registry Password:
        - Kind: Secret text
        - ID: DOCKER_REGISTRY_PASSWORD
        - Secret: <docker_hub_account_password>
    3. GitHub Username:
        - Kind: Secret text
        - ID: GITHUB_USERNAME
        - Secret: 1653072
    4. GitHub Personal Access Token:
        - Kind: Username with password
        - ID: GITHUB_PERSONAL_ACCESS_TOKEN 
        - Username: Kienquoctran08@gmail.com or 1653072
        - Password: <personal_access_token> 
    5. Final Project K8S Manifest Repository URL:
        - Kind: Secret text
        - ID: FINAL_PROJECT_MANIFEST_REPO_URL
        - Secret: https://github.com/1653072/techmaster-final-project-obo-manifest.git
    6. Final Project K8S Manifest Repository Name:
        - Kind: Secret text
        - ID: FINAL_PROJECT_MANIFEST_REPO_NAME
        - Secret: techmaster-final-project-obo-manifest
    ```

## Setup 3: Jenkins Multibranch Pipeline

- TBD

## Setup 4: ArgoCD

- TBD

## Setup 5: Prometheus & Grafana

- TBD

