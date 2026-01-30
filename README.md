# Terraform Setup for Lendscape infrastructure

This Terraform configuration is designed for setting up resources in the Test AWS account. It lays out the structure and resources required for the DMZ, Application VPCs, security groups, target groups, and load balancers.

## Prerequisites

- Ensure you have Terraform installed. If not, follow the [official Terraform installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- AWS CLI should be installed and properly configured with the necessary profiles.
- You need appropriate permissions in AWS to assume the roles specified in the Terraform provider.

## Structure

1. **Global Variables**: These are imported from an external module and are used across various other modules.
2. **DMZ VPC**: This sets up a VPC for the Demilitarized Zone.
3. **Application VPC**: Configures the main application VPC.
4. **Security Groups**: Sets up security groups for resources in the DMZ and Application VPCs.
5. **Target Groups**: These are set up for load balancing.
6. **Load Balancers**: Configures the application load balancers.

## Backend

Terraform's state management is handled using an S3 backend. This allows multiple developers to work on the infrastructure without stepping on each other's toes. The DynamoDB table is used for state locking to prevent any conflicts during concurrent runs.

## Provider

The configuration uses the AWS provider (provider.tf) in the client-XXXX/environment folder. Default tags are applied to all resources managed by Terraform, aiding in cost tracking and management.

## Setup Instructions
1. **User account**: Your user in the Shared Account should be able to assume a role from the destination account
2. **User credentials**: Paste your AWS secret temporary credentials in your $HOME/.aws/credentials and $HOME/.aws/config files to create a profile called: lendscape-shared-services
3. **Working directory**: Change to the client-XXXX/environment directory (example below)
   ```bash
   cd ./client-0000/test
4. **Initialization**:
   ```bash
   terraform init
5. **Plan**:
   ```bash
   terraform plan
6. **Review**: Review the output plan
7. **Apply**:
   ```bash
   terraform plan

## How to create a new environment
1. **Provising a new account**: Use AFT module to do it
2. **(Optional) Role deployment**: If AFT module hasn't deployed the required role yet (to be implemented) use the CF template ( ```cf-templates/TerraformAdministratorServiceRole.yaml```) on the new account
3. **Duplicate folder**: Copy the content ```client0000-test``` inside a new folder of root project folder with a different name: ```client0000-prod``` for instance
4. **Modify environment values**: Modify the content of the file ```client-0000/prod/locals.tf``` as required
5. **Modify provider values**: Modify the content of the file ```client-0000/prod/provider.tf```.
   ```bash
   key            = "terraform/<region>/<customer>/terraform.tfstate"
   # Example
   key            = "terraform/eu-west-2/0000poc-prod/terraform.tfstate"
   # And for the role
   role_arn     = "arn:aws:iam::<destination_account_id>:role/TerraformAdministratorServiceRoleCF"
6. **Working directory**: Change to the client-0000/prod directory (just as example)
   ```bash
   cd ./client-0000/prod
7. **Init and Plan**:
   ```bash
   terraform init && terraform plan
8. **Review**: Review the output plan
9. **Apply**:
   ```bash
   terraform apply

## Granting Internet Outbound to Private instances in APP VPC

There is a flag in any ```client-XXXX/environment/locals.tf``` that allows to temporary grant access to the internet to the private instances (never inbound traffic). This is a temporary implementation until TGW and Firewalls are in place and allow internet traffic. The variable is called ```install_egress_access```
## Helpers
Warning: Links are not working, this is not a finished feature and it's not commited, but it will help.
Using docker you can generate all the documentation for all the terraform code thanks to terraform-docs. There's an script that will use list_of_main_tf_paths.txt (you don't need to modify this one) and any extra module that you want to document will be picked from modules_to_document.txt. Some links won't be working but the folder structure is preserved.

## AppStream 2.0 optional submodule
In order to add new users to Cognito User Pool (Lendscape wants to avoid self-registration by users in the public website) run the following command:
```bash
aws cognito-idp admin-set-user-password --user-pool-id <your_user_pool_id> --username <user_email> --password '<password>' --permanent --region <region_of_the_user_pool>
