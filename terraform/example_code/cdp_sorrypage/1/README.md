# nifcloud terraform cdp_sorry_page_example1 sample
* https://pfs.nifcloud.com/cdp/app/sorry_page.htm
## How to run

1. create ssh-key file. recommended: SSH-RSA 2048bit.
2. rename the ssh-key file to pubkey.pub.
3. run `terraform init` to install NIFCLOUD Provider.
4. define environment variables NIFCLOUD_DEFAULT_REGION,NIFCLOUD_ACCESS_KEY_ID, NIFCLOUD_SECRET_ACCESS_KEY. 
   * Command Prompt
     * export NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * export NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
   * PowerShell
     * $ENV:NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * $ENV:NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
5. Add the following content to the firewall.tf file
   * cidr_ip = "xxx.xxx.xxx.xxx"
     * Enter the access source IP address to access via SSH　　
6. run `terraform plan` to check change plan.
7. exec `terraform apply`
