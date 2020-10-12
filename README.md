# terraform-rds-postgres-demo

## How to use
### Create database password file - on windows
```
mkdir secrets
echo "Your_DB_Password" > secrets/postgresdb-password.txt
```

### Execute IaC scripts
```
terraform init
terraform plan
terraform apply
terraform destroy
```