from nifcloud import session
import sys

# ---- define name -------
PRIVATE_LAN_NAME = 'Private02'
CONNECT_SERVER_NAME = 'db001'
# -------------------------


# -------- Add Interfacd --------------------------------

def wait_for_private_network_config(client, private_lan_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('private_lan_available')
        wait_result = waiter.wait(
            PrivateLanName=[
                private_lan_name,
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


def add_interface(client):
    try:
        privatelan = client.nifty_describe_private_lans(
            PrivateLanName=[PRIVATE_LAN_NAME, ]
        )
        """
        response = client.create_network_interface(
            # memo
            Description='string',
            # Set Ipaddress
            # See https://pfs.nifcloud.com/api/rest/CreateNetworkInterface.htm
            IpAddress='string',
            # Connect Network
            # net-COMMON_GLOBAL :Common Global
            # net-COMMON_PRIVATE:Common Private
            # NetworkID         :Network ID at Private LAN
            NiftyNetworkId='string',
            #Zone Name.
            Placement={
                'AvailabilityZone': 'string'
            }
        )
        """
        interface_info = client.create_network_interface(
            # memo
            Description='memo ex connect server name',
            NiftyNetworkId=privatelan['PrivateLanSet'][0]['NetworkId'],
            # if network dhcp use not set IpAddress
            # IpAddress='string',
            # Zone Name.
            Placement={
                'AvailabilityZone': 'east-21'
            }
        )
        wait_for_private_network_config(client, PRIVATE_LAN_NAME)

        result = client.attach_network_interface(
            InstanceId=CONNECT_SERVER_NAME,
            NetworkInterfaceId=interface_info['NetworkInterface']
                                             ['NetworkInterfaceId'],
            NiftyReboot='false'
        )
        if result['Return']:
            print("Fail : Add Interface")
            sys.exit(1)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)
add_interface(client)
