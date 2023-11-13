# nifcloud terraform cdp_fw sample
* https://pfs.nifcloud.com/cdp/basic/fw.htm
## How to run

1. create ssh-key file.recommendation SSH-RSA 2048bit.
2. modify the ssh-key file name to pubkey.pub.
3. run `terrafrom init` to install NIFCLOUD Provider.
4. define environment variables NIFCLOUD_ACCESS_KEY_ID And NIFCLOUD_SECRET_ACCESS_KEY. 
   * Command Prompt
     * export NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * export NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
   * PowerShell
     * $ENV:NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * $ENV:NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
5. Add the following content to the firewall.tf file
   * cidr_ip = "xxx.xxx.xxx.xxx"
     * Enter the access source IP address to access via SSH  
   * cidr_ip = "xxx.xxx.xxx.xxx"
     * Enter the access source IP address to access via http  
   * cidr_ip = "xxx.xxx.xxx.xxx"
     * Enter the access source IP address to access via https  
5. run `terraform plan` to check change plan.
6. exec `terraform apply`