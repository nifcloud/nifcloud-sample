from nifcloud import session
import sys


# -------- Show Firewall --------------------------------------
def parse_instancesSet(instancesset):
    print("InstanceId :")
    for instance in instancesset:
        print("\t", instance["InstanceId"])


def parse_ipPermissions(ippermissions):
    for index, permission in enumerate(ippermissions):
        print("Roule[%03i] :" % index)
        print("\tDescription :", permission["Description"])
        print("\tIN/OUT      :", permission["InOut"])
        print("\tProtocol    :", permission["IpProtocol"])
        if permission["IpProtocol"] != "ANY":
            print("\tPort        : %i - %i" %
                  (permission["FromPort"], permission["ToPort"]))
        if "IpRanges" in permission:
            print("\tIP/CIDR     :", permission["IpRanges"][0]["CidrIp"])
        if "groups" in permission:
            print("\tGroup       :", permission["Groups"][0]["GroupName"])


def parse_routerSet(routerset):
    print("RouterSet :")
    for router in routerset:
        router["routerName"]


def parse_vpnGatewaySet(vpnGatewayset):
    print("VpnGatewaySet :")
    for vpngateway in vpnGatewayset:
        print("\t", vpngateway["NiftyVpnGatewayName"])


def get_fw(client):
    try:
        fws = client. describe_security_groups()
        for fw in fws["SecurityGroupInfo"]:
            print("---------------------------------------")
            for key in ["GroupName",
                        "GroupDescription",
                        "AvailabilityZone",
                        "GroupLogFilterBroadcast",
                        "GroupLogFilterNetBios",
                        "GroupLogLimit",
                        "GroupRuleLimit",
                        ]:
                if key in fw:
                    print(key, ":", fw[key])

            if "InstancesSet" in fw:
                parse_instancesSet(fw["InstancesSet"])
            if "IpPermissions" in fw:
                parse_ipPermissions(fw["IpPermissions"])
            if "RouterSet" in fw:
                parse_routerSet(fw["RouterSet"])
            if "VpnGatewaySet" in fw:
                parse_vpnGatewaySet(fw["VpnGatewaySet"])

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-3",
)

get_fw(client)
