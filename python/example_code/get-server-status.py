from nifcloud import session
import sys


def parse_networkInterfaceSet(networkInterfaceSet):
    for index, networkinterface in enumerate(networkInterfaceSet):
        print("Interface[%03i] :" % index)
        # --- connect Network name -----------
        networkname = ""
        if networkinterface["NiftyNetworkId"] in \
           ["net-COMMON_GLOBAL", "net-COMMON_PRIVATE", "net-MULTI_IP_ADDRESS"]:
            networkname = networkinterface["NiftyNetworkId"][4:]
        else:
            networkname = networkinterface["NiftyNetworkName"]
        print("\tNetworkName :", networkname)
        # ---- IP Address ---------
        ipaddress = "0.0.0.0"
        if "Association" in networkinterface:
            ipaddress = networkinterface["Association"]["PublicIp"]
        elif "PrivateIpAddress" in networkinterface:
            ipaddress = networkinterface["PrivateIpAddress"]
        else:
            ipaddress = "---"
        print("\tIPAddress :", ipaddress)


def parse_multiIpAddressGroup(multiIpAddressGroup):
    if "multiIpAddressGroup" in multiIpAddressGroup:
        print("MultiIpAddressGroup :",
              multiIpAddressGroup["multiIpAddressGroup"])


def parse_placement(placement):
    print("AvailabilityZone :", placement["AvailabilityZone"])


def parse_instanceState(instanceState):
    print("InstanceState :", instanceState["Name"])


def parse_instanceBackupRule(instanceBackupRule):
    if "instanceBackupRuleName" in instanceBackupRule:
        print("instanceBackupRuleName ",
              instanceBackupRule["instanceBackupRuleName"])


def parse_blockDeviceMapping(blockDeviceMapping):
    print("BlockDeviceMapping :")
    for blockDevice in blockDeviceMapping:
        print("\tVolumeId :", blockDevice["Ebs"]["VolumeId"])
        print("\tDeleteOnTermination :",
              blockDevice["Ebs"]["DeleteOnTermination"])


def parse_Loadbalancing(loadbalancing):
    print("Loadbalancing :")
    for lb in loadbalancing:
        print("\tLoadbalancingName :", lb["LoadBalancerName"])


def get_instance(client):
    try:
        instances_infomation = client.describe_instances()
        for instances in instances_infomation["ReservationSet"]:
            print("---------------------------------------")
            for instance in instances["InstancesSet"]:
                for key in ["InstanceId",
                            "AccountingType",
                            "Description",
                            "ImageName",
                            "InstanceType",
                            "KeyName",
                            "LaunchTime",
                            ]:
                    if key in instance:
                        print(key, ":", instance[key])

                if "NetworkInterfaceSet" in instance:
                    parse_networkInterfaceSet(instance["NetworkInterfaceSet"])
                if "MultiIpAddressGroup" in instance:
                    parse_multiIpAddressGroup(instance["MultiIpAddressGroup"])
                if "Placement" in instance:
                    parse_placement(instance["Placement"])
                if "InstanceState" in instance:
                    parse_instanceState(instance["InstanceState"])
                if "InstanceBackupRule" in instance:
                    parse_instanceBackupRule(instance["InstanceBackupRule"])
                if "BlockDeviceMapping" in instance:
                    parse_blockDeviceMapping(instance["BlockDeviceMapping"])
                if "Loadbalancing" in instance:
                    parse_Loadbalancing(instance["Loadbalancing"])

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-1",
)


get_instance(client)
