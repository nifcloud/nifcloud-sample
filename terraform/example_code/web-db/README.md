# terraform sample

## nifcloud-basic-demo
### How to run
1. create ssh-key file. recommended: SSH-RSA 2048bit.
2. rename the ssh-key file to pubkey.pub.
3. run `terraform init` to install NIFCLOUD Provider.
4. define environment variables NIFCLOUD_ACCESS_KEY_ID and NIFCLOUD_SECRET_ACCESS_KEY. 
5. run `terraform plan` to check change plan.
6. exec `terraform apply`
