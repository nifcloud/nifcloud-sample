# nifcloud terraform cdp_disk sample
* https://pfs.nifcloud.com/cdp/basic/disk.htm
## How to run

### Add Disk

1. run `terraform init` to install NIFCLOUD Provider.
2. define environment variables NIFCLOUD_DEFAULT_REGION,NIFCLOUD_ACCESS_KEY_ID, NIFCLOUD_SECRET_ACCESS_KEY. 
   * Command Prompt
     * export NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * export NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
   * PowerShell
     * $ENV:NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * $ENV:NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
3. Edit the parameter `cidr_ip` in the firewall.tf file.
   * cidr_ip="xxx.xxx.xxx.xxx"
     * Set the IP address of the terminal that connects via SSH.
4. run `terraform plan` to check change plan.
5. exec `terraform apply`  
   The server is created with the disks attached.

### Detach Disk
1. Edit `server.tf`
2. Comment out the `instance_id` parameter for the volume.disk resource
3. run `terraform plan` to check change plan.
4. exec `terraform apply`  
   Detached disk from the server.

