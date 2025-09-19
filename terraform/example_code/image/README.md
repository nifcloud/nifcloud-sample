# nifcloud terraform cdp_multi_lb_private sample
* https://pfs.nifcloud.com/cdp/advanced/image.htm
## How to run

1. Create a server image in advance and record the image name.
2. run `terraform init` to install NIFCLOUD Provider.
3. define environment variables NIFCLOUD_DEFAULT_REGION,NIFCLOUD_ACCESS_KEY_ID, NIFCLOUD_SECRET_ACCESS_KEY. 
   * Command Prompt
     * export NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * export NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
   * PowerShell
     * $ENV:NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * $ENV:NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
4. Edit the parameter `image_name ` of `\image\os_image.tf`, insert the image name recorded in step 1.
5. run `terraform plan` to check change plan.
6. exec `terraform apply`
