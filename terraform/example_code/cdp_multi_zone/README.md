# nifcloud terraform cdp_multi_zone sample
* https://pfs.nifcloud.com/cdp/advanced/multi_zone.htm
## How to run

1. create ssh-key file.recommendation SSH-RSA 2048bit.
2. rename the ssh-key file to pubkey.pub.
3. run `terraform init` to install NIFCLOUD Provider.
4. define environment variables NIFCLOUD_ACCESS_KEY_ID And NIFCLOUD_SECRET_ACCESS_KEY. 
   * Command Prompt
     * export NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * export NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
   * PowerShell
     * $ENV:NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * $ENV:NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
5. Edit the parameter `cidr_ip` in the east-13-firewall.tf and east-14-firewall.tf file.
   * cidr_ip="xxx.xxx.xxx.xxx"
     * Edit to the access source IP address that is accessed by SSH.
6. run `terraform plan` to check change plan.
7. exec `terraform apply`
8. Next, manually connect the private LANs using a private bridge.
   * Create Connectors
     * Create one connector for each private LAN. When created, a connector ID will be automatically assigned.
   * Create a Private Bridge
   * Add Reachability
     * Before connecting the connectors, add reachability to the private bridge.
   * Connect the Connectors
     * Connect the connectors to the private bridge. Select the private bridge and specify the connector ID.
   * Verify server connectivity
     * Confirm communication between DB servers via the private bridge.
