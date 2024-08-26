**Overview**

The Terraform state is managed using Amazon S3 buckets for each environment (qa, and prd). Each environment has a dedicated bucket for storing the Terraform state files, and DynamoDB is used for state locking to ensure consistency.

**Prerequisites**

Configure AWS Credentials and Setup Terraform

**Set up AWS credentials**:

aws configure

You will be prompted to enter your AWS Access Key ID, Secret Access Key, region, and output format.

**Terraform**

1. Change the working directory to the terraform folder \
   `cd terraform`
2. Initialize Terraform, replace `<env>` with *qa*, or *prd*: \
   `terraform init --backend-config=aws.<env>.cfg -reconfigure`
3. Plan the deployment and verify that changes changes are correct: \
   `terraform plan --var-file=00_<env>_variables.tfvars`
4. Apply the deployment: \
   `terraform apply --var-file=00_<env>_variables.tfvars`

**Note**: *Applying Terraform directly from a local machine is a bad practice because it can lead to inconsistencies in the infrastructure state, security risks, and lack of audit trails. It's recommended to use a CI/CD pipeline for Terraform deployments to ensure consistent, secure, and trackable infrastructure changes.*