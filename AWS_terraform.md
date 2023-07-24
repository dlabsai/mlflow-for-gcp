# Ml Flow on AWS setup
## AWS CLI
- Install AWS CLI - [link to instruction](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Generate key for the user that you will be using to manage terraform resources - [link to the instruction](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)
- Login using `aws configure` command

## Terraform setup
- Terraform version used here :  v1.5.0
- Install terraform - [link to the official documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- Install terraform - docs for automatic documentation (optional) [terraform-docs](https://terraform-docs.io/user-guide/installation/)

## Create bucket for terraform state
- For terraform to work optimally we should store our terraform state in cloud. You can store it locally but it is not recommended. [Details about terraform state.](https://developer.hashicorp.com/terraform/language/state)
- Go to Amazon S3 and click Create Bucket
- Choose a name and region for your bucket 
- You can leave the rest of the settings default

## Initial terraform setup
- change `bucket` value in `main.tf` file to name of the bucket you just created
- adjust `variables.tf` and `local.tf` so the data matches your project, if you are not using vpn use `0.0.0.0/0` instead (it will make your application available from any IP)
- run `terraform init`

### Documentation for terraform elements [HERE](terraform/AWS/README.md)

## Create ECR and push image
- create ECR using command `terraform apply -target=aws_ecr_repository.mlflow_ecr`
- build image base on Dockerfile from `/mlflow-gcp/AWS`
- upload image to ECR with tag `latest` - [official instruction](https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html)


### Commands for pushing to ECR
Change `region`, `aws_account_id`, `repository_name` and `imgine_id`
so it matches your project.

- authenticate docker for aws 

`aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com`

- tag your imagine 

`docker tag imgine_id aws_account_id.dkr.ecr.region.amazonaws.com/repository_name:latest`

- push your imagine to AWS

`docker push aws_account_id.dkr.ecr.region.amazonaws.com/repository_name:latest`

## Set up rest of infrastructure 
- use `terraform plan` to review what elements will be created 
- use `terraform apply` to set up the rest of the infrastructure (it will take a while)

## Testing 
- in folder `AWS/sample_client` create `.env` file base on template
- `check_tracking.py` - uploads an artifact to the bucket, it will be visible in MlFlow GUI 
- `upload_model.py` - uploads more advanced model