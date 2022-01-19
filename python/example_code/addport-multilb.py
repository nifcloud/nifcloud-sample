from nifcloud import session
import sys

# --- define --------
# -- MULTILB Name -------
MULTILB_NAME = "web"
MULTILB_ADD_WAIT_PORT = 1080
MULTILB_ADD_TARGET_PORT = 200
MULTILB_ADD_PROTOCOL = 'TCP'
# --------------------
# -------------------

# ----- Create Multi Load Barancer -----------------------


def wait_for_multi_lb_config(client, mlb_name):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('elastic_load_balancer_available')
        wait_result = waiter.wait(
            ElasticLoadBalancers={
                'ListOfRequestElasticLoadBalancerName':[
                    mlb_name,
                ],
            },
            Filter=[
                {
                    'ListOfRequestValue': [
                        'available',
                    ],
                    'Name': 'state',
                },
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


def create_multi_lb(client):
    try:
        # Add Port Load Barancer
        """
        client.nifty_register_port_with_elastic_load_balancer(
            # Target Load Balancer
            ElasticLoadBalancerId='string',# Load Balancer Id(Exclusive Name)
            ElasticLoadBalancerName='string',# Load Balancer Name(Exclusive Id)
            Listeners=[
                {
                    'BalancingType': 1,# 1:Round-Robin(Default)
                                       # 2:Least-Connection
                    'Description': 'string', # memo
                    'Protocol': 'string', #LoadBalanceProtocol.Can be set 'TCP','UDP','HTTP' and 'HTTPS'
                    'ElasticLoadBalancerPort': 123,# Waiting Port.Can set range 1-65535
                    'InstancePort': 123,# Target Server Port.Can set range 1-65535
                    'SSLCertificateId': 'string' # SSL Certificate ID.
                },
            ]
        )
        """
        client.nifty_register_port_with_elastic_load_balancer(
            # Target Load Balancer
            ElasticLoadBalancerName=MULTILB_NAME,# Load Balancer Name
            Listeners=[
                {
                    'BalancingType': 1,# 1:Round-Robin(Default)
                    'Description': 'add confgi', # memo
                    'Protocol': MULTILB_ADD_PROTOCOL, #LoadBalanceProtocol.
                    'ElasticLoadBalancerPort': MULTILB_ADD_WAIT_PORT,# Waiting Port.Can set range 1-65535
                    'InstancePort': MULTILB_ADD_TARGET_PORT,# Target Server Port.Can set range 1-65535
                },
            ]
        )
        wait_for_multi_lb_config(client, MULTILB_NAME)

        #  Register Server
        """
        client.nifty_register_instances_with_elastic_load_balancer(
            # Target Load Balancer
            ElasticLoadBalancerId='string',# Load Balancer Id(Exclusive Name)
            ElasticLoadBalancerName='string',# Load Balancer Name(Exclusive Id)
            ElasticLoadBalancerPort=123,# Waiting Port.Can set range 1-65535
            InstancePort=123,# Target Server Port.Can set range 1-65535
            Protocol='TCP'|'UDP'|'HTTP'|'HTTPS'#LoadBalanceProtocol
            # Instance Infomation
            Instances=[
                {
                    'InstanceId': 'string', # Server Id(Exclusive Name)
                    'InstanceUniqueId': 'string'# Server Name(Exclusive Id)
                },
            ],
        )
        """
        client.nifty_register_instances_with_elastic_load_balancer(
            # Target Load Balancer
            ElasticLoadBalancerName=MULTILB_NAME,# Load Balancer Name
            ElasticLoadBalancerPort=MULTILB_ADD_WAIT_PORT,# Waiting Port.Can set range 1-65535
            InstancePort=MULTILB_ADD_TARGET_PORT,# Target Server Port.Can set range 1-65535
            Protocol=MULTILB_ADD_PROTOCOL, #LoadBalanceProtocol.Can be set 'TCP','UDP','HTTP' and 'HTTPS'
            # Instance Infomation
            Instances=[
                { 'InstanceId': 'web001' },
                { 'InstanceId': 'web002' },
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


create_multi_lb(client)
