**Overview**
The Terraform state is managed using Amazon S3 buckets for each environment (qa, and prd). Each environment has a dedicated bucket for storing the Terraform state files, and DynamoDB is used for state locking to ensure consistency.

**Prerequisites**
Install AWS CLI and Terraform

**On macOS with Homebrew**:

brew install awscli
brew install terraform

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