from nifcloud import session
import sys

# --- define --------
# -- L4LB Name -------
L4LB_NAME = "web"
L4LB_WAIT_PORT = 8080
L4LB_TARGET_PORT = 80
# --------------------
# -------------------

# ----- Create L4 Load Barancer -----------------------


def wait_for_l4lb_create(client, l4lb_name, l4lb_wait_port, l4lb_target_port):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('load_balancer_exists')
        wait_result = waiter.wait(
            LoadBalancerNames=[
                {
                    'LoadBalancerName': l4lb_name,
                    'LoadBalancerPort': l4lb_wait_port,
                    'InstancePort': l4lb_target_port,
                },
            ],
            Owner="all",
            WaiterConfig={
                'Delay': 20,
                'MaxAttempts': 40
            }
        )

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
    finally:
        return wait_result


def create_l4lb(client):
    try:
        # Create Load Barancer
        """
        result = client.create_load_balancer(
                    LoadBalancerName='string', #Load Balancer Name
                    AccountingType='1',#'1':Monthly(Default)
                                       #'2':Payper
                    AvailabilityZones=[
                        'string',
                    ],
                    IpVersion='v4',# Global IP Type. Can select 'v4'(Default) or 'v6'
                    Listeners=[#Balancing Rule
                        {
                            'BalancingType': 1,# 1:Round-Robin(Default)
                                               # 2:Least-Connection
                            'InstancePort': 123,# Target Server Port
                            'LoadBalancerPort': 123, # Waiting Port(Exclusive Protocol)
                            'Protocol': 'HTTP'|'HTTPS'|'FTP'
                                            # Waiting Service(Exclusive LoadBalancerPort)
                        },
                    ],
                    NetworkVolume=10,# Max Network Traffic.
                                     # See also https://pfs.nifcloud.com/api/rest/CreateLoadBalancer.htm
                    PolicyType='standard' # Encrypt type
                                          # standard: Not ATS Support(Default)
                                          # ats: ATS Support
                )
        """
        client.create_load_balancer(
            LoadBalancerName=L4LB_NAME,  # Load Balancer Name
            AccountingType='2',  # '1':Monthly(Default)
            # '2':Payper
            IpVersion='v4',  # Global IP Type. Can select 'v4'(Default) or 'v6'
            Listeners=[  # Balancing Rule
                {
                    'BalancingType': 1,  # 1:Round-Robin(Default)
                    'InstancePort': L4LB_TARGET_PORT,  # Target Server Port
                    # Waiting Port(Exclusive Protocol)
                    'LoadBalancerPort': L4LB_WAIT_PORT,
                },
            ],
            NetworkVolume=10,  # Max Network Traffic.
            PolicyType='standard'  # Encrypt type
            # standard: Not ATS Support(Default)
        )
        wait_for_l4lb_create(
            client, L4LB_NAME, L4LB_WAIT_PORT, L4LB_TARGET_PORT)

        # Config Helth Check
        """
        client.configure_health_check(
            # target LoadBrancer
            LoadBalancerName='string', #Load Balancer Name
            InstancePort=123, # Target Server Port
            LoadBalancerPort=123, # Waiting Port(Exclusive Protocol)
            # Helth Check config
            HealthCheck={
                'HealthyThreshold': 1, #Number of times to Re-Enable in Service.
                'Interval': 30, # Healtcheck interval.5-300s
                'Target': 'string', # Helthcheck Protocol.
                                    # "ICMP":Using ICMP
                                    # "TCP:Number": Using TCP. with specifi number
                'UnhealthyThreshold': 3 # Helth check threshold
            },
        )
        """
        client.configure_health_check(
            # target LoadBrancer
            LoadBalancerName=L4LB_NAME,  # Load Balancer Name
            InstancePort=L4LB_TARGET_PORT,  # Target Server Port
            # Waiting Port(Exclusive Protocol)
            LoadBalancerPort=L4LB_WAIT_PORT,
            # Helth Check config
            HealthCheck={
                # Number of times to Re-Enable in Service.
                'HealthyThreshold': 1,
                'Interval': 30,  # Healtcheck interval.5-300s
                'Target': f"TCP:{L4LB_TARGET_PORT}",
                'UnhealthyThreshold': 3  # Helth check threshold
            },
        )

        # Filter Setting
        """
        client.set_filter_for_load_balancer(
            # target LoadBrancer
            LoadBalancerName='string', #Load Balancer Name
            InstancePort=123, # Target Server Port
            LoadBalancerPort=123, # Waiting Port(Exclusive Protocol)
            FilterType='1'|'2',# Filtring type
                               # 1:Accept
                               # 2:Deny
            IPAddresses=[
                {
                    'AddOnFilter': True,# Operation Type
                                        # True:Add IP address(default)
                                        # False:Delete IP address
                    'IPAddress': 'string'# Source IP address
                },
            ],
        )
        """
        client.set_filter_for_load_balancer(
            # target LoadBrancer
            LoadBalancerName=L4LB_NAME,  # Load Balancer Name
            InstancePort=L4LB_TARGET_PORT,  # Target Server Port
            LoadBalancerPort=L4LB_WAIT_PORT, # Waiting Port(Exclusive Protocol)
            FilterType='1',
            IPAddresses=[
                {
                    'AddOnFilter': True,
                    'IPAddress': '8.8.8.8'# Source IP address
                },
                {
                    'AddOnFilter': True,
                    'IPAddress': '8.8.4.4'# Source IP address
                },
            ],
        )

        # Register Servers
        """
        client.register_instances_with_load_balancer(
            # target LoadBrancer
            LoadBalancerName='string', #Load Balancer Name
            InstancePort=123, # Target Server Port
            LoadBalancerPort=123, # Waiting Port(Exclusive Protocol)
            # Tareget Server List
            Instances=[
                {
                    'InstanceId': 'string'
                },
            ],
        )
        """
        client.register_instances_with_load_balancer(
            # target LoadBrancer
            LoadBalancerName=L4LB_NAME,  # Load Balancer Name
            InstancePort=L4LB_TARGET_PORT,  # Target Server Port
            LoadBalancerPort=L4LB_WAIT_PORT, # Waiting Port(Exclusive Protocol)
            Instances=[  # Tareget Server List
                {
                    'InstanceId':'web001',
                },
                {
                    'InstanceId':'web002',
                },
            ],
        )


    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)


create_l4lb(client)
