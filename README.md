# demo-project-deck
demo-project-deck

This terraform project creates a AWS EC2 instance with debian Bullseye and
deploys postgres and kong.

Finally a deck file with a sample kongfiguration is installed.

To make this work change in <add-your-own> terraform.tfvars

```javascript
aws_access_key = "<add-your-own>"
aws_secret_key = "<add-your-own>"
```
Then call 
```
terraform init
terraform plan
terraform apply -auto-approve
```
lean back.
