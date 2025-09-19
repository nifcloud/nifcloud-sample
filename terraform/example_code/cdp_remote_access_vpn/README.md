# nifcloud terraform cdp_remote_access_vpn sample
* https://pfs.nifcloud.com/cdp/advanced/ra_vpngw.htm
## How to run
1. create ssh-key file. recommended: SSH-RSA 2048bit.
2. rename the ssh-key file to pubkey.pub.
3. run `terraform init` to install NIFCLOUD Provider.
4. define environment variables NIFCLOUD_ACCESS_KEY_ID and NIFCLOUD_SECRET_ACCESS_KEY. 
5. Prepare the certificates for the Remote Access VPN Gateway.
6. Upload the CA certificate that signed the client certificate.
    After uploading, confirm the "CA certificate ID".
7. Add the following content to the remote_access_vpn_gateway.tf file:
   * ca_certificate_id = "cac-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
     * Enter the "CA certificate ID" that you confirmed in step 6.
8. Place the certificates in the cert folder with the following file names:
   * private_key.pem (Private Key of the Server Certificate)
   * certificate.pem (Server Certificate)
9. run `terraform plan` to check change plan.
10. run `terraform apply`

