# nifcloud terraform cdp_cross_region sample
* https://pfs.nifcloud.com/cdp/advanced/privatebridge.htm
## How to run

1. create ssh-key file.recommendation SSH-RSA 2048bit.
2. modify the ssh-key file name to pubkey.pub.
3. run `terraform init` to install NIFCLOUD Provider.
4. define environment variables NIFCLOUD_ACCESS_KEY_ID And NIFCLOUD_SECRET_ACCESS_KEY. 
   * Command Prompt
     * export NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * export NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
   * PowerShell
     * $ENV:NIFCLOUD_ACCESS_KEY_ID="xxxxx"
     * $ENV:NIFCLOUD_SECRET_ACCESS_KEY="xxxxx"
5. run `terraform plan` to check change plan.
6. exec `terraform apply`
7. Next, manually connect the private LANs using a private bridge.
   * Create Connectors
     * Create one connector for each private LAN. When created, a connector ID will be automatically assigned.
   * Create a Private Bridge
   * Add Reachability
     * Before connecting the connectors, add reachability to the private bridge.
   * Connect the Connectors
     * Connect the connectors to the private bridge. Select the private bridge and specify the connector ID.
   * Verify server connectivity
     * Confirm communication between DB servers via the private bridge.
