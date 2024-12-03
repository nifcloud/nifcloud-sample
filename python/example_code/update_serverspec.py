from nifcloud import session
import sys

# --- define --------
# -- Server -------
SERVER_NAME = "testsv"
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


def update_instance_attr(client, server_name):
    try:
        """
        client.modify_instance_attribute(
            # Target Instance Name
            InstanceId='Server Name',
            # Update Target Parameter
            # instanceType         :Instance Spec
            # disableApiTermination:Permmit Delete by API
            # instanceName         :Instance Name
            # description          :Description
            # ipType               :Global IP Type(static,none)
            # groupId              :Firewall Group
            # accountingType       :Accounting Type(Payper/Monthry)
            Attribute=string,
            # Update Value
            # See also
            # https://docs.nifcloud.com/cp/api/ModifyInstanceAttribute.htm
            Value='string',
            # Reboot Option
            # force:Force reboot
            # true:Normal ACPI Reboot(default)
            # false:Not Reboot
            NiftyReboot='true',
            # in HotScaleUp
            # only use NiftyReboot is false
            # True :Force ScaleUp
            # False:Not Force ScaleUp(default)
            Force=False,
            # Tenancy
            # dafault  :Normal(default)
            # dedicated:Dedicated Instance
            Tenancy='dafault',
        )
        """
        # FireWallGroup Change
        client.modify_instance_attribute(
            InstanceId=server_name,
            Attribute='groupId',
            Value='AfterFW',
            NiftyReboot='false',
        )
        print("FireWallGroup Change")
        wait_for_instance_running(client, server_name)
        # Accounting Change
        client.modify_instance_attribute(
            InstanceId=server_name,
            Attribute='accountingType',
            # Monthry :1
            # Payper  :2
            Value='1',
            NiftyReboot='false',
        )
        print("Accounting Change")
        wait_for_instance_running(client, server_name)
        # Spec Change
        client.modify_instance_attribute(
            InstanceId=server_name,
            Attribute='instanceType',
            Value='c-small4',
            NiftyReboot='true',
        )
        print("Spec Change")
        wait_for_instance_running(client, server_name)
        # Global IP Remove
        client.modify_instance_attribute(
            InstanceId=server_name,
            Attribute='ipType',
            Value='none',
            NiftyReboot='false',
        )
        print("Global IP Remove")
        wait_for_instance_running(client, server_name)
    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)


update_instance_attr(client)
