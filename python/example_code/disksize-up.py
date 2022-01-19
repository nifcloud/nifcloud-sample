from nifcloud import session
import sys

# --- define -----
DISK_NAME = "testvol"

# ----- DiskSize Up ---------------------------------------------


def wait_for_diskedit(client, disk_name):
    print("wait : ", sys._getframe().f_code.co_name)

    try:
        waiter = client.get_waiter('volume_in_use')
        wait_result = waiter.wait(
            VolumeId=[
                disk_name,
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


def extend_disk(client):
    try:
        disks_status = client.describe_volumes(VolumeId=[DISK_NAME])
        disk_status = disks_status['VolumeSet'][0]
        # requiest server connect for disk size icrease operation
        if disk_status['Status'] != "in-use":
            raise
        """
        # 100G Increase per one call
        client.extend_volume_size(
            NiftyReboot='true',#Connect Server Reboot?
                               #true : Reboot Server(normal reboot)
                               #force: Reboot Server(force reboot)
                               #false: No Reboot Server
            VolumeId='string'#VolumeName
        )
        """
        for i in range(2):  # Increase 200G
            print("increase %-3d" % i)
            client.extend_volume_size(
                NiftyReboot='false',  # false: No Reboot Server
                VolumeId=DISK_NAME  # VolumeName
            )
            wait_for_diskedit(client, DISK_NAME)
    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)

extend_disk(client)
