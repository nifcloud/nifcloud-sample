# nifcloud terraform cdp_multi_lb_private sample
* https://pfs.nifcloud.com/cdp/app/multi_lb_private.htm
## How to run

1. create ssh-key file.recommendation SSH-RSA 2048bit.
2. modify the ssh-key file name to pubkey.pub.
3. run `terrafrom init` to install NIFCLOUD Provider.
4. define environment variables NIFCLOUD_DEFAULT_REGION,NIFCLOUD_ACCESS_KEY_ID, NIFCLOUD_SECRET_ACCESS_KEY. 
   * Command Prompt
     * export NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * export NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
   * PowerShell
     * $ENV:NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * $ENV:NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
5. Preparing the sorry page
  * Use object storage service
    * Bucket creation
    * Store sorry page in bucket
    * Get URL to Sorry Page
6. Enter the URL of the sorry page obtained in 5 to the multiloadbalancer.tf file
  * sorry_page_redirect_url = "http://exsample.com"
7. run `terraform plan` to check change plan.
8. exec `terraform apply`
