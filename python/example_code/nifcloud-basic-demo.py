from nifcloud import session
import sys
import base64

# ---- define name -------
# -- key name ----------
SSH_KYE_FILE_NAME = 'key.pub'
EAST31_KEY_NAME   = "key"
# -- security group ----
WEB_SECURITY_GP_NAME = "webfw"
DB_SECURITY_GP_NAME  = "dbfw"
# -- Private LAN name ---
WEB_DB_PRV_NET_NAME = "webdbnet"
# -- Router name ---
WEB_DB_ROUTER_NAME = "webdbRtr"
# -------------------------


# -------- Create Firewall --------------------------------------
def wait_for_fw_create(client, sg_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('security_group_exists')
        wait_result = waiter.wait(
            Filter=[
                {
                    'ListOfRequestValue': [
                        'applied',
                    ],
                    'Name': 'group-name'
                },
            ],
            GroupName=[sg_name, ],
            WaiterConfig={
                'Delay': 20,
                'MaxAttempts': 40
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def wait_for_fw_applied(client, sg_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('security_group_applied')
        wait_result = waiter.wait(
            Filter=[
                {
                    'ListOfRequestValue': [
                        'applied',
                    ],
                    'Name': 'group-name'
                },
            ],
            GroupName=[sg_name, ],
            WaiterConfig={
                'Delay': 20,
                'MaxAttempts': 40
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def create_fw(client):
    try:
        sg = client.create_security_group(
            GroupName=WEB_SECURITY_GP_NAME,
            GroupDescription="WEB FW"
        )

        print("create : ", sg)
        wait_for_fw_create(client, WEB_SECURITY_GP_NAME)

        sg = client.create_security_group(
            GroupName=DB_SECURITY_GP_NAME,
            GroupDescription="DB FW"
        )
        print("create : ", sg)
        wait_for_fw_create(client, WEB_SECURITY_GP_NAME)

        # -------------- web fw -----------------------------
        client.authorize_security_group_ingress(
            GroupName=WEB_SECURITY_GP_NAME,
            IpPermissions=[
                {
                    'Description': 'class b allow',
                    'InOut': 'IN',
                    'IpProtocol': 'ANY',
                    'ListOfRequestIpRanges': [
                        {
                            'CidrIp': "192.168.2.0/24",
                        },
                    ],
                },
            ]
        )
        wait_for_fw_applied(client, WEB_SECURITY_GP_NAME)

        client.authorize_security_group_ingress(
            GroupName=WEB_SECURITY_GP_NAME,
            IpPermissions=[
                {
                    'Description': 'DB alow',
                    'InOut': 'IN',
                    'IpProtocol': 'ANY',
                    'ListOfRequestGroups': [
                        {
                            'GroupName': DB_SECURITY_GP_NAME,
                        },
                    ],
                },
            ]
        )
        wait_for_fw_applied(client, WEB_SECURITY_GP_NAME)

        client.authorize_security_group_ingress(
            GroupName=WEB_SECURITY_GP_NAME,
            IpPermissions=[
                {
                    'Description': 'ssh allow(example IP)',
                    'FromPort': 22,
                    'ToPort': 22,
                    'InOut': 'IN',
                    'IpProtocol': 'TCP',
                    'ListOfRequestIpRanges': [
                        {
                            'CidrIp': "203.0.113.1",
                        },
                    ],
                },
            ]
        )
        wait_for_fw_applied(client, WEB_SECURITY_GP_NAME)

        # ------------- dbfw ----------------------------
        client.authorize_security_group_ingress(
            GroupName=DB_SECURITY_GP_NAME,
            IpPermissions=[
                {
                    'Description': 'DB alow',
                    'InOut': 'IN',
                    'IpProtocol': 'ANY',
                    'ListOfRequestGroups': [
                        {
                            'GroupName': WEB_SECURITY_GP_NAME,
                        },
                    ],
                },
            ]
        )
        wait_for_fw_applied(client, DB_SECURITY_GP_NAME)

        client.authorize_security_group_ingress(
            GroupName=DB_SECURITY_GP_NAME,
            IpPermissions=[
                {
                    'Description': 'class b allow',
                    'InOut': 'IN',
                    'IpProtocol': 'ANY',
                    'ListOfRequestIpRanges': [
                        {
                            'CidrIp': "192.168.2.0/24",
                        },
                    ],
                },
            ]
        )
        wait_for_fw_applied(client, DB_SECURITY_GP_NAME)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        client.delete_security_group(
            GroupName=WEB_SECURITY_GP_NAME,
        )
        client.delete_security_group(
            GroupName=DB_SECURITY_GP_NAME,
        )
        sys.exit(1)

# ------ Create Virtual Server ----------------------------------


def wait_for_instance_create(client, instance_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('instance_running')
        wait_result = waiter.wait(
            InstanceId=[instance_name, ],
            Tenancy=['all', ],
            WaiterConfig={  # Wait 10 min with a check interval of 30s.
                'Delay': 30,
                'MaxAttempts': 20
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def wait_for_instance_stop(client, instance_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('instance_stopped')
        wait_result = waiter.wait(
            InstanceId=[instance_name, ],
            Tenancy=['all', ],
            WaiterConfig={  # Wait 10 min with a check interval of 30s.
                'Delay': 30,
                'MaxAttempts': 20
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def create_instance(client):
    try:
        """
        client.run_instances(
            AccountingType='2',#'1':Monthly
                               #'2':Payper(Default)
            Admin='string',#Windows Admin User Name
            Agreement="False",#True:License Agree for SPLA,RHEL and anymore.
                              #     see also https://pfs.nifcloud.com/service/licence_ms.htm
                              #     https://pfs.nifcloud.com/service/rhel.htm
                              #False:Not License Agree(Default)
            Description='string',# memo
            DisableApiTermination=True,#True :Not Allow to delete from API(Default)
                                       #False:Allow to delete from API
            ImageId='string',   #OS Image Name
            InstanceId='string',#Server Name
            InstanceType="",#Server Type
                            #see also https://docs.nifcloud.com/cp/api/RunInstances.htm
            KeyName='string',#SSH Key Name
            License=[#License Infomation.see also https://pfs.nifcloud.com/service/licence_ms.htm
                {#No.1 License Info
                    'LicenseName': 'RDS'|'Office(Std)'|'Office(Pro Plus)',
                    'LicenseNum' : 'string'
                },
                #...
                {#No.N License Info
                    'LicenseName': 'RDS'|'Office(Std)'|'Office(Pro Plus)',
                    'LicenseNum' : 'string'
                },
            ],
            IpType='',#'static' :Use Global IP
                      #'elastic':Use Replacement IP.Shuld set PublicIp
                      #'none'   :Not Use Global IP
            PublicIp='string',#If you use Replacement IP set this
            NetworkInterface=[#Network Config.
                {#Full argument
                    'IpAddress': 'string',#See also NetworkInterface.n.IpAddress in
                                          #https://docs.nifcloud.com/cp/api/RunInstances.htm
                                          #if use the DHCP delete this
                    'NetworkId': 'string',#Connect Network
                                          #net-COMMON_GLOBAL :Common Global
                                          #net-COMMON_PRIVATE:Common Private
                                          #NetworkID         :Network ID at Private LAN
                    'NetworkName': 'string'
                },
                {#Common Private DHCP sample
                    'NetworkId': 'net-COMMON_PRIVATE',
                },
            ],
            Password='string',#Password for Windows Admin user
            Placement={
                'AvailabilityZone': 'string',#Zone Name.
                                             #For jp-east-1, east-11,east-12,east-13,east-14 can be selected.
                                             #For jp-west-1, west-11,west-12,west-13 can be selected.
            },
            SecurityGroup=[#Firewall Group name
                'string',
            ],
            UserData={#Server Boot Script
                'Content': 'string',#Encoded Server Boot Script body
                'Encoding': 'string'#Encoding Type
                                    #''      :text
                                    #'base64':base64 encode(Default)
            }
        )

        """
        client.run_instances(
            AccountingType='2',
            Description='web sv',
            DisableApiTermination=False,
            ImageId='220',
            InstanceId='websv',
            InstanceType="e-small4",
            KeyName=EAST31_KEY_NAME,
            IpType='static',
            NetworkInterface=[
                {
                    'NetworkName': WEB_DB_PRV_NET_NAME,
                },
            ],
            Placement={
                'AvailabilityZone': 'east-31',
            },
            SecurityGroup=[
                WEB_SECURITY_GP_NAME,
            ],
        )
        wait_for_instance_create(client, 'websv')

        client.run_instances(
            AccountingType='2',
            Description='DB sv',
            DisableApiTermination=False,
            ImageId='220',
            InstanceId='dbsv',
            InstanceType="e-small4",
            KeyName=EAST31_KEY_NAME,
            IpType='none',
            NetworkInterface=[
                {
                    'NetworkName': WEB_DB_PRV_NET_NAME,
                },
            ],
            Placement={
                'AvailabilityZone': 'east-31',
            },
            SecurityGroup=[
                WEB_SECURITY_GP_NAME,
            ],
        )
        wait_for_instance_create(client, 'dbsv')
    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        client.stop_instances(
            Force=True,
            InstanceId=[
                'websv',
            ],
        )
        wait_for_instance_stop(client, 'websv')
        client.terminate_instances(
            InstanceId=[
                'websv',
            ]
        )
        client.stop_instances(
            Force=True,
            InstanceId=[
                'dbsv',
            ],
        )
        wait_for_instance_stop(client, 'dbsv')
        client.terminate_instances(
            InstanceId=[
                'dbsv',
            ]
        )
        sys.exit(1)

# ----- import ssh key ------------------------------------------


def import_sshkey(client):
    try:
        with open(SSH_KYE_FILE_NAME, "rb") as ssh_pub_file:
            client.import_key_pair(
                Description='memo',
                KeyName=EAST31_KEY_NAME,
                PublicKeyMaterial=base64.b64encode(
                    ssh_pub_file.read()).decode("ascii")
            )
    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)

# ----- Create Private LAN --------------------------------------


def wait_for_private_lan_create(client, private_lan_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('private_lan_exists')
        wait_result = waiter.wait(
            Filter=[
                {
                    'ListOfRequestValue': [
                        'available',
                    ],
                    'Name': 'state'
                },
            ],
            PrivateLanName=[private_lan_name, ],
            WaiterConfig={
                'Delay': 20,
                'MaxAttempts': 40
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def create_private_lan(client):
    try:
        """
        client.nifty_create_private_lan(
            AccountingType   = '2',#'1':Monthly
                                   #'2':Payper(Default)
            AvailabilityZone = 'string',#Zone Name.east-31,east-11,west-12 and more
            CidrBlock        = 'string',#CIDR for Private LAN address
            Description      = 'string',#memo
            PrivateLanName   = 'string'#Private LAN Name
        )
        """
        client.nifty_create_private_lan(
            AccountingType='2',  # '1':Monthly
            AvailabilityZone='east-31',  # Zone Name.east-31,east-11,west-12 and more
            CidrBlock='192.168.170.0/24',  # CIDR for Private LAN address
            Description='memo',  # memo
            PrivateLanName=WEB_DB_PRV_NET_NAME  # Private LAN Name
        )
        wait_for_private_lan_create(client, WEB_DB_PRV_NET_NAME)
    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        client.nifty_delete_private_lan(
            PrivateLanName=WEB_DB_PRV_NET_NAME
        )
        sys.exit(1)
# ------ Create Private LAN DHCP Router -------------------------


def wait_for_create_router(client, router_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('router_exists')
        wait_result = waiter.wait(
            Filter=[
                {
                    'ListOfRequestValue': [
                        'available',
                    ],
                    'Name': 'state'
                },
            ],
            RouterName=[
                router_name,
            ],
            WaiterConfig={  # Wait 10 min with a check interval of 30s.
                'Delay': 30,
                'MaxAttempts': 20
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def enable_dhcp(client):
    # Create DHCP Config
    dhcp_config_resutl = client.nifty_create_dhcp_config()
    dhcp_config_id = dhcp_config_resutl['DhcpConfig']['DhcpConfigId']
    # DHCP Setting ADD
    client.nifty_create_dhcp_ip_address_pool(
        Description='memo',  # memo
        DhcpConfigId=dhcp_config_id,  # DHCP Config ID
        StartIpAddress='192.168.170.100',  # DHCP Start IP
        StopIpAddress='192.168.170.250'  # DHCP End IP
    )
    # Create Router
    """
    client.nifty_create_router(
        AccountingType   = '2',#'1':Monthly
                               #'2':Payper(Default)
        RouterName       = 'string',#Router Name
        AvailabilityZone = 'string',#Zone Name.east-31,east-11,west-12 and more
        Description      = 'string', #memo
        NetworkInterface=[
            {
                'Dhcp'         : True, #True :DHCP Enable.Request after item(Default)
                                       #False:DHCP Disable
                'DhcpConfigId' : 'string',#DHCP Config ID
                'DhcpOptionsId': 'string',#DHCP Option ID
                'IpAddress'    : 'string',#IP Address at Connectted Private LAN
                'NetworkId'    : 'string',#Select Setting Network.Exclusive NetworkName
                'NetworkName'  : 'string' #Select Setting Network.Exclusive NetwokId
            },
        ],
        SecurityGroup=[#Firewall Group(Option)
            'string',
        ],
        Type='small'#'small' :Max 10 Rule(Default)
                    #'medium':Max 30 Rule
                    #'large' :Max 80 Rule
    )
    """
    client.nifty_create_router(
        AccountingType='2',
        RouterName=WEB_DB_ROUTER_NAME,
        AvailabilityZone='east-31',
        Description='memo',  # memo
        NetworkInterface=[
            {
                'Dhcp': True,
                'DhcpConfigId': dhcp_config_id,
                'IpAddress': '192.168.170.1',
                'NetworkName': WEB_DB_PRV_NET_NAME
            },
        ],
        Type='small'
    )
    wait_for_create_router(client, WEB_DB_ROUTER_NAME)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-3",
)
import_sshkey(client)
create_fw(client)
create_private_lan(client)
enable_dhcp(client)
create_instance(client)
