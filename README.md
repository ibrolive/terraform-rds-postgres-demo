# terraform-rds-postgres-demo
Terraform script to provision postgres database.

## How to use
### Create database password file
#### On windows
```
mkdir secrets
echo|set /p="Your_DB_Password" > secrets/postgresdb-password.txt
```

#### On Linux
```
mkdir secrets
printf "Your_DB_Password" > secrets/postgresdb-password.txt
```

### Execute IaC scripts
```
terraform init
terraform plan
terraform apply
terraform destroy
```

If you're looking for a simpler version, see - https://blog.faraday.io/how-to-create-an-rds-instance-with-terraform/

For a more recent version, see - https://github.com/terraform-aws-modules/terraform-aws-rds/tree/master/examples/complete-postgres