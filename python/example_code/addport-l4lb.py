from nifcloud import session
import sys

# --- define --------
# -- L4LB Name -------
L4LB_NAME = "web"
L4LB_NEW_WAIT_PORT = 8090
L4LB_NEW_TARGET_PORT = 90
# --------------------
# -------------------

# ----- Add Port L4 Load Barancer -----------------------

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

def add_port_l4lb(client):
    try:
        """
        client.register_port_with_load_balancer(
            LoadBalancerName='string', #Load Balancer Name
            Listeners=[#Balancing Rule
                {
                    'BalancingType': 1,# 1:Round-Robin(Default)
                                       # 2:Least-Connection
                    'InstancePort': 123,# Target Server Port
                    'LoadBalancerPort': 123, # Waiting Port(Exclusive Protocol)
                    'Protocol': 'HTTP'|'HTTPS'|'FTP'
                                    # Waiting Service(Exclusive LoadBalancerPort)
                },
        )
        """
        client.register_port_with_load_balancer(
            LoadBalancerName=L4LB_NAME,  # Load Balancer Name
            Listeners=[  # Balancing Rule
                {
                    'BalancingType': 1,  # 1:Round-Robin(Default)
                    'InstancePort': L4LB_NEW_TARGET_PORT,  # Target Server Port
                    # Waiting Port(Exclusive Protocol)
                    'LoadBalancerPort': L4LB_NEW_WAIT_PORT,
                },
            ],
        )
        wait_for_l4lb_create(
            client, L4LB_NAME, L4LB_NEW_WAIT_PORT, L4LB_NEW_TARGET_PORT)

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
            InstancePort=L4LB_NEW_TARGET_PORT,  # Target Server Port
            LoadBalancerPort=L4LB_NEW_WAIT_PORT, # Waiting Port(Exclusive Protocol)
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


add_port_l4lb(client)
