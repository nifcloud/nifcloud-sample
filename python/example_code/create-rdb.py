from nifcloud import session
import sys
import base64

# ---- define name -------
# -- Create AZ-----
AZ = "east-11"
# -- rdb ----
RDB_NAME="pytest"
RDB_SECURITY_GP_NAME = "rdbfw"
RDB_CONFIG_GROUP_NAME = "pytest"
RDB_VIP='198.51.100.200/24'
RDB_MASTER_IP='198.51.100.201/24'
RDB_SLAVLE_IP='198.51.100.202/24'
# -- Private LAN name ---
PRV_NET_NAME = "pyrdbtst"
# -- Private LAN Range ----
PRIVATE_LAN_CIDER = '198.51.100.0/24'
# -------------------------


# -------- Create Firewall --------------------------------------
def wait_for_rdb_fw_create(client, rdb_sg_name):
    print("wait : ", sys._getframe().f_code.co_name)
    wait_result = None
    try:
        waiter = client.get_waiter('db_security_group_exists')
        wait_result = waiter.wait(
            DBSecurityGroupName=rdb_sg_name,
            WaiterConfig={
                'Delay': 40,
                'MaxAttempts': 80
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def wait_for_rdb_fw_ingress(client, rdb_sg_name):
    print("wait : ", sys._getframe().f_code.co_name)
    wait_result = None
    try:
        waiter = client.get_waiter('db_security_group_ip_ranges_authorized')
        wait_result = waiter.wait(
            DBSecurityGroupName=rdb_sg_name,
            WaiterConfig={
                'Delay': 20,
                'MaxAttempts': 40
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def create_rdb_fw(client):
    try:
        """
        client.create_db_security_group(
            # RDB Firewall Group Name
            DBSecurityGroupName='string',
            # memo
            DBSecurityGroupDescription='string',
            #Zone Name.
            #For jp-east-1, you can select east-11,east-12,east-13,east-14.
            #For jp-east-2, you can select east-21.
            #For jp-west-1, you can select west-11,west-12,west-13.
            NiftyAvailabilityZone='string'
        )
        """
        rdbsg = client.create_db_security_group(
            # RDB Firewall Group Name
            DBSecurityGroupName=RDB_SECURITY_GP_NAME,
            # memo
            DBSecurityGroupDescription='sample fw',
            # Zone Name.
            # For jp-east-1, you can select east-11,east-12,east-13,east-14.
            # For jp-east-2, you can select east-21.
            # For jp-west-1, you can select west-11,west-12,west-13.
            NiftyAvailabilityZone=AZ
        )

        print("create : ", rdbsg)
        wait_for_rdb_fw_create(client, RDB_SECURITY_GP_NAME)

        # -------------- allow rule -----------------------------
        """
        client.authorize_db_security_group_ingress(
            # Target RDB Security Group
            DBSecurityGroupName=RDB_SECURITY_GP_NAME,
            # Allow Security Group.Only same zone
            EC2SecurityGroupName="string",
            # Allow IP Range
            CIDRIP="0.0.0.0/0"
        )
        """
        client.authorize_db_security_group_ingress(
            DBSecurityGroupName=RDB_SECURITY_GP_NAME,
            # Allow IP Range
            CIDRIP=PRIVATE_LAN_CIDER
        )
        wait_for_rdb_fw_ingress(client, RDB_SECURITY_GP_NAME)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        client.delete_db_security_group(
            DBSecurityGroupName=RDB_SECURITY_GP_NAME,
        )
        sys.exit(1)

# ------ Create RDB ----------------------------------


def wait_for_rdb_create(client, rdb_name):
    print("wait : ", sys._getframe().f_code.co_name)
    wait_result = None
    try:
        waiter = client.get_waiter('db_instance_available')
        wait_result = waiter.wait(
            DBInstanceIdentifier = rdb_name,
            WaiterConfig={
                'Delay': 40,
                'MaxAttempts': 80
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def wait_for_rdp_delete(client, rdb_name):
    print("wait : ", sys._getframe().f_code.co_name)
    wait_result = None
    try:
        waiter = client.get_waiter('db_instance_deleted')
        wait_result = waiter.wait(
            DBInstanceIdentifier=rdb_name,
            WaiterConfig={
                'Delay': 40,
                'MaxAttempts': 80
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def create_rdb_parameter(client):
    try:
        rdbparam = client.create_db_parameter_group(
            # Config Name
            DBParameterGroupName=RDB_CONFIG_GROUP_NAME,
            # memo
            Description='string',
            # Database Parameter Family name
            # See also "DBParameterGroupFamily" specifiction
            DBParameterGroupFamily='mysql5.7',
        )
        print("create : ", rdbparam)
    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        client.delete_db_parameter_group(
            DBParameterGroupName=RDB_CONFIG_GROUP_NAME
        )
        sys.exit(1)

def create_rdb(client,pvlanid):
    try:
        """
        client.create_db_instance(
            # Master Document https://docs.nifcloud.com/rdb/api/CreateDBInstance.htm
            # Accounting
            # '1':Monthly
            # '2':Payper(Default)
            AccountingType='2',
            # RDB Name
            DBInstanceIdentifier='string',
            # Create Zone Name.
            AvailabilityZone='string',
            # DB Type
            DBInstanceClass='db.small4',
            # Disk Size.50,100,150,200 or 250
            AllocatedStorage=50,
            # Database Engine.See "Engine" specifiction
            Engine='string',
            # Database Engine Version.See "EngineVersion" specifiction
            EngineVersion='string',
            # --- Database Setting ---
            # Database Name
            DBName='string',
            # Database usename
            MasterUsername='string',
            # Database password
            MasterUserPassword='string',
            # Database Disk Type
            # 0:First Disk(HDD)(default)
            # 1:Flash Disk
            NiftyStorageType=0,
            # --- Network Config
            # Database waiting port.
            Port=3306,
            # Connect PriveteLAN ID
            NiftyNetworkId='string',
            # Internal LoadBalancer VIP
            NiftyVirtualPrivateAddress='string',
            #  Master Instance IP
            NiftyMasterPrivateAddress='string',
            # Database Paramater Group Name
            DBParameterGroupName='string',
            # Security Group
            DBSecurityGroups=[
                'string',
            ],
            # Using Global Network.Inherited to the replica.True(default) / Flase
            PubliclyAccessible=True,
            # --- Backup Config -----
            # Backup retention.0-10 day(0 to no backup)
            BackupRetentionPeriod=2,
            # -- Redundant Config --
            # Enable Redundant.True / False
            MultiAZ=True,
            # Secondry DB IP
            # if MultiAZ is True
            NiftySlavePrivateAddress='string',
            # Backup time range.Set by UTC Time
            # See "PreferredBackupWindow" specifiction
            PreferredBackupWindow='18:00-18:30',
            # -- Maitenace Config --
            # Maitenance Time Range.Set by UTC Time
            # See "PreferredMaintenanceWindow" specifiction
            PreferredMaintenanceWindow='sun:19:00-sun:19:30',
        )
        """
        rdb = client.create_db_instance(
            AccountingType='2',
            DBInstanceIdentifier=RDB_NAME,
            AvailabilityZone=AZ,
            DBInstanceClass='db.small4',
            AllocatedStorage=50,
            Engine='MySQL',
            EngineVersion='5.7.15',
            DBName='pydb',
            MasterUsername='usename',
            MasterUserPassword='barbarbarupd',
            NiftyStorageType=0,
            # --- Network Config
            Port=3306,
            NiftyNetworkId=pvlanid,
            # Internal LoadBalancer VIP
            NiftyVirtualPrivateAddress=RDB_VIP,
            #  Master Instance IP
            NiftyMasterPrivateAddress=RDB_MASTER_IP,
            DBParameterGroupName=RDB_CONFIG_GROUP_NAME,
            DBSecurityGroups=[
                RDB_SECURITY_GP_NAME,
            ],
            PubliclyAccessible=False,
            # --- Backup Config -----
            BackupRetentionPeriod=2,
            # -- Redundant Config --
            MultiAZ=True,
            NiftySlavePrivateAddress=RDB_SLAVLE_IP,
            PreferredBackupWindow='18:00-18:30',
            # -- Maitenace Config --
            PreferredMaintenanceWindow='sun:19:00-sun:19:30',
        )
        print("create : ", rdb)
        wait_for_rdb_create(client, RDB_NAME)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        client.delete_db_instance(
           DBInstanceIdentifier=f"{RDB_NAME}-read",
           # if Create snapshot.True / False
           SkipFinalSnapshot=False,
           # snapshot name
           #FinalDBSnapshotIdentifier='string',
        )
        wait_for_rdp_delete(client, f"{RDB_NAME}-read")

        client.delete_db_instance(
           DBInstanceIdentifier=RDB_NAME,
           # if Create snapshot.True / False
           SkipFinalSnapshot=False,
           # snapshot name
           #FinalDBSnapshotIdentifier='string',
        )
        wait_for_rdp_delete(client, RDB_NAME)
        sys.exit(1)


# ----- Create Private LAN --------------------------------------


def wait_for_private_lan_create(client, private_lan_name):
    print("wait : ", sys._getframe().f_code.co_name)
    wait_result = None
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
                'Delay': 40,
                'MaxAttempts': 80
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
            AvailabilityZone = 'string',#Zone Name.
                                        #For jp-east-1, east-11,east-12,east-13,east-14 can be selected.
                                        #For jp-west-1, west-11,west-12,west-13 can be selected.
            CidrBlock        = 'string',#CIDR for Private LAN address
            Description      = 'string',#memo
            PrivateLanName   = 'string'#Private LAN Name
        )
        """
        pvlan = client.nifty_create_private_lan(
            PrivateLanName=PRV_NET_NAME, # Private LAN Name
            AccountingType='2',  # '1':Monthly
            AvailabilityZone=AZ,  # Zone Name.east-31,east-11,west-12 and more
            CidrBlock=PRIVATE_LAN_CIDER,  # CIDR for Private LAN address
            Description='memo',  # memo
        )
        print("create : ", pvlan)
        wait_for_private_lan_create(client, PRV_NET_NAME)
        return pvlan['PrivateLan']['NetworkId']
    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        client.nifty_delete_private_lan(
            PrivateLanName=PRV_NET_NAME
        )
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-1",
)
rdbclient = session.get_session().create_client(
    "rdb",
    region_name="jp-east-1",
)
pvlanid = create_private_lan(client)
create_rdb_fw(rdbclient)
create_rdb_parameter(rdbclient)
create_rdb(rdbclient,pvlanid)

# flake8: noqa: E501
