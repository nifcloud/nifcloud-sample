from nifcloud import session
import sys

# --- define --------
# -- VPNGW -------
VPNGW_NAME = "vpngw01"
# --------------------

# -- PRIVATE NW -------
PRIVATE_NW_NAME = 'test'
PRIVATE_NW_CIDR = '10.0.0.2'
# --------------------
# -------------------

# ----- Create VPN Gateway -----------------------


def wait_for_vpngw_create(client, vpngw_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('vpn_gateway_exists')
        wait_result = waiter.wait(
            Filter=[
                {
                    'ListOfRequestValue': [
                        'available',
                    ],
                    'Name': 'state',
                },
            ],
            NiftyVpnGatewayName=[
                vpngw_name,
            ],
            WaiterConfig={
                'Delay': 20,
                'MaxAttempts': 40
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def create_vpngw(client):
    try:
        # Create Load Barancer
        """
        client.create_vpn_gateway(
            AccountingType='1',#'1':Monthly(Default)
                               #'2':Payper
            NiftyVpnGatewayName='string', # VPN Gateway name
            NiftyVpnGatewayDescription='string', # memo
            # VPN Gateway spec.'small','medium' or 'large'
            NiftyVpnGatewayType='small',
            # for Connecting a global network to a private LAN
            # Set exclusively with NetworkInterface
            NiftyNetwork={
                # Connect Network ID
                # Set exclusively with NetworkName
                'NetworkId': 'string',
                # Connect Network Name
                # Set exclusively with NetworkID
                'NetworkName': 'string',
                #set only when connected to a Private LAN
                #if use the DHCP delete this
                'IpAddress': 'string',
            },
            # for Connecting a private LAN to a private LAN
            # Set exclusively with NiftyNetwork
            NetworkInterface=[
                # opposing device side network
                {
                    # Connect Network ID
                    # Set exclusively with NetworkName
                    'NetworkId': 'string',
                    # Connect Network Name
                    # Set exclusively with NetworkID
                    'NetworkName': 'string',
                    # Set IPaddress in Private Network
                    'IpAddress': 'string',
                    # opposing device side network is to set "IsOutsideNetwork" True
                    'IsOutsideNetwork': True
                },
                # Private side network
                {
                    # Connect Network ID
                    # Set exclusively with NetworkName
                    'NetworkId': 'string',
                    # Connect Network Name
                    # Set exclusively with NetworkID
                    'NetworkName': 'string',
                    # Set IPaddress in Private Network
                    'IpAddress': 'string',
                    # Private side network is to set "IsOutsideNetwork" False
                    'IsOutsideNetwork': False,
                },
            ],
            #Zone Name.
            Placement={
                'AvailabilityZone': 'string'
            },
            # Security Group
            SecurityGroup=[
                'string',
            ],
        )
        """
        client.create_vpn_gateway(
            AccountingType='2',
            NiftyVpnGatewayName=VPNGW_NAME,
            NiftyVpnGatewayDescription='memo',
            NiftyVpnGatewayType='small',
            NiftyNetwork={
                'NetworkName': PRIVATE_NW_NAME,
                'IpAddress': PRIVATE_NW_IP,
            },
            Placement={
                'AvailabilityZone': 'east-21'
            },
            SecurityGroup=[
                'test',
            ],
        )
        wait_for_vpngw_create(client, VPNGW_NAME)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)


create_vpngw(client)
