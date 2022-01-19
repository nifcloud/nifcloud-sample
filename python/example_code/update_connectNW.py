from nifcloud import session
import sys

# --- define --------
# -- Server -------
SERVER_NAME = "testsv"
# --------------------
# -- PRIVATE NW -------
PRIVATE_NW_NAME = 'test'
PRIVATE_NW_IP = 'static'
# --------------------
# -------------------

# ------  update attribute --------------------


def wait_for_instance_running(client, instance_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('instance_running')
        wait_result = waiter.wait(
            InstanceId=[instance_name, ],
            Tenancy=['all', ],
            WaiterConfig={
                'Delay': 30,
                'MaxAttempts': 40
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def wait_for_instance_warning(client):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('instance_warning')
        wait_result = waiter.wait(
            InstanceId=[SERVER_NAME, ],
            Tenancy=['all', ],
            WaiterConfig={
                'Delay': 30,
                'MaxAttempts': 40
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


# ---- change the private Network to which the private NIC is connected

def update_private_network(client, server_name):
    try:
        """
        client.nifty_update_instance_network_interfaces(
            # Target Instance Name
            InstanceId='string',
            # After Network Config
            NetworkInterface=[
                {
                    #Select Setting Network.Exclusive NetworkName
                    'NetworkId'    : 'string',
                    #Select Setting Network.Exclusive NetwokId
                    'NetworkName'  : 'string',
                    #See also NetworkInterface.n.IpAddress in
                    #https://pfs.nifcloud.com/api/rest/NiftyUpdateInstanceNetworkInterfaces.htm
                    'IpAddress'    : 'string',
                },
            ],
            # Reboot Option
            # force:Force reboot
            # true:Normal ACPI Reboot(default)
            # false:Not Reboot
            NiftyReboot='true',
        )
        """
        client.nifty_update_instance_network_interfaces(
            InstanceId=server_name,
            # After Network Config
            NetworkInterface=[
                {
                    'NetworkName': PRIVATE_NW_NAME,
                    'IpAddress': PRIVATE_NW_IP,
                },
            ],
            NiftyReboot='true',
        )
        print("Private Network Change")
    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)


update_private_network(client)
