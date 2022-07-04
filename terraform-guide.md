# Terraform
`terraform init`
Set up terraform environment on localhost

`terraform plan`
Make terraform aware of our action plan

`terraform apply`
Apply the action plan 

`terraform destroy`
terminating the instance

Within `main.tf`  
    var `provider "<provider>"`: we can specify our cloud provider, e.g.
        `region`

    `resource`: specify the resource we want to create

When `terraform apply` being run, terraform.tfstate will check if there is any new changes between the main.tf and current instance state. If there is any changes, the updates will be applied.


Short summary of Terraform: https://www.youtube.com/watch?v=tomUWcQ0P3k

Longer summary of Terraform: https://www.youtube.com/watch?v=l5k1ai_GBDE&t=6s

Long tutorial on Terraform: https://www.youtube.com/watch?v=SLB_c_ayRMo
