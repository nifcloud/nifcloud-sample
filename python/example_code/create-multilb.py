from nifcloud import session
import sys

# --- define --------
# -- MULTILB Name -------
MULTILB_NAME = "web"
MULTILB_WAIT_PORT = 8080
MULTILB_TARGET_PORT = 80
MULTILB_PROTOCOL = 'HTTP'
# --------------------
# -------------------

# ----- Create Multi Load Balancer -----------------------


def wait_for_multi_lb_create(client, mlb_name, mlb_wait_port, mlb_target_port, mlb_protocol):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('elastic_load_balancer_available')
        wait_result = waiter.wait(
            ElasticLoadBalancers={
                'ListOfRequestElasticLoadBalancerName':[
                    mlb_name,
                ],
                'ListOfRequestElasticLoadBalancerPort':[
                    mlb_wait_port,
                ],
                'ListOfRequestInstancePort':[
                    mlb_target_port,
                ],
                'ListOfRequestProtocol':[
                    mlb_protocol,
                ],
            },
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
        # Create Load Balancer
        """
        client.nifty_create_elastic_load_balancer(
            ElasticLoadBalancerName='string',# Load Balancer Name
            AccountingType='2',#'1':Monthly
                               #'2':Payper(Default)
            AvailabilityZones=[
                'string',
            ],
            # Load Balancer Config
            Listeners=[
                {
                    'BalancingType': 1,# 1:Round-Robin(Default)
                                       # 2:Least-Connection
                    'Description': 'string', # memo
                    'Protocol': 'string', #LoadBalanceProtocol.Can be set 'TCP','UDP','HTTP' and 'HTTPS'
                    'ElasticLoadBalancerPort': 123,# Waiting Port.Can set range 1-65535
                    'InstancePort': 123,# Target Server Port.Can set range 1-65535
                    # Health Cehck Config
                    'RequestHealthCheck': {
                        'Target': 'string', # Helth Cehck Protocol
                                            # in TCP: 'TCP:PortNumber'
                                            # in HTTP: 'HTTP:PortNumber'
                                            # in HTTPS: 'HTTPS:PortNumber'
                        # if Target is only set at HTTP or HTTPS,can specify it. 
                        # Healthcheck url path.ex '/hoge/check.png'
                        'Path': 'string',
                        'Interval': 5,# Healtcheck interval.5(default)-300s.
                        'UnhealthyThreshold': 1,# Healthcheck Limit Threshold.1(default)-10
                        'ListOfRequestExpectation': [
                            # if Target is only set at HTTP or HTTPS,can specify it. 
                            # HTTP code that is considered normal
                            {
                                'HttpCode': 123 
                            },
                        ],
                    },
                    # Session Sticky Policy
                    'RequestSession': {
                        'RequestStickinessPolicy': {
                            # Use Session Sticky:True / False
                            'Enable': True|False,
                            # Session retention time.unit is minutes
                            'ExpirationPeriod': 30,
                            # Sticky Type
                            'Method': '1', # 1:Source IP
                                           # 2:Cookie
                        }
                    },
                    # Sorry page Policy
                    'RequestSorryPage': {
                        # Use Sorry Page:True / False
                        'Enable': True,
                        # Sorry Page URL
                        'RedirectUrl': 'http://example.com/sorry.html'
                    },
                    # SSL Certificate ID.
                    'SSLCertificateId': 'string'
                },
            ],
            NetworkInterface=[
                {
                    'IpAddress': 'string',#See also NetworkInterface.n.IpAddress in
                                          #https://pfs.nifcloud.com/api/rest/NiftyCreateElasticLoadBalancer.htm
                                          #if use the DHCP delete this
                    'NetworkId': 'string',#Connect Network.Exclusive NetworkName.
                                          #net-COMMON_GLOBAL :Common Global
                                          #net-COMMON_PRIVATE:Common Private
                                          #NetworkID         :Network ID at Private LAN
                    'NetworkName': 'string',#Private LAN name.Exclusive NetworkId.
                    'IsVipNetwork': True,# Is Load Balancer reception interface:True / False
                },
            ],
            NetworkVolume=10,# Max Network Traffic.
                             # See also https://pfs.nifcloud.com/api/rest/NiftyCreateElasticLoadBalancer.htm
        )
        """
        client.nifty_create_elastic_load_balancer(
            ElasticLoadBalancerName=MULTILB_NAME,# Load Balancer Name
            AccountingType='2', #'2':Payper(Default)
            AvailabilityZones=[
                'east-21',
            ],
            # Load Balancer Config
            Listeners=[
                {
                    'BalancingType': 1,# 1:Round-Robin(Default)
                    'Description': 'memo', # memo
                    'Protocol': MULTILB_PROTOCOL, #LoadBalanceProtocol.Can be set 'TCP','UDP','HTTP' and 'HTTPS'
                    'ElasticLoadBalancerPort': MULTILB_WAIT_PORT,# Waiting Port.Can set range 1-65535
                    'InstancePort': MULTILB_TARGET_PORT,# Target Server Port.Can set range 1-65535
                    # Health Cehck Config
                    'RequestHealthCheck': {
                        'Target': f'{MULTILB_PROTOCOL}:{MULTILB_TARGET_PORT}', # Helth Cehck Protocol
                        # if Target is only set at HTTP or HTTPS,can specify it. 
                        # Healthcheck url path.ex '/hoge/check.png'
                        'Path': '/',
                        'Interval': 5,# Healtcheck interval.5(default)-300s.
                        'UnhealthyThreshold': 1,# Healthcheck Limit Threshold.1(default)-10
                        'ListOfRequestExpectation': [
                            # if Target is only set at HTTP or HTTPS,can specify it. 
                            # HTTP code that is considered normal
                            { 'HttpCode': 200 },
                            { 'HttpCode': 201 },
                            { 'HttpCode': 202 },
                            { 'HttpCode': 203 },
                            { 'HttpCode': 204 },
                            { 'HttpCode': 205 },
                            { 'HttpCode': 206 },
                            { 'HttpCode': 207 },
                            { 'HttpCode': 208 },
                            { 'HttpCode': 226 },
                        ],
                    },
                    # Session Sticky Policy
                    'RequestSession': {
                        'RequestStickinessPolicy': {
                            # Use Session Sticky:True / False
                            'Enable': True,
                            # Session retention time.unit is minutes
                            'ExpirationPeriod': 30,
                            # Sticky Type
                            'Method': '1', # 1:Source IP
                        }
                    },
                    # Sorry page Policy
                    'RequestSorryPage': {
                        # Use Sorry Page:True / False
                        'Enable': True,
                        # Sorry Page URL
                        'RedirectUrl': 'http://example.com/sorry.html'
                    },
                },
            ],
            NetworkInterface=[
                {
                    'NetworkId': 'net-COMMON_GLOBAL',#Connect Network.Exclusive NetworkName.
                                          #net-COMMON_GLOBAL :Common Global
                    'IsVipNetwork': True,# Is Load Balancer reception interface:True / False
                },
                {
                    'IpAddress': '192.168.10.235',
                    'NetworkName': 'Private01',#Private LAN name.Exclusive NetworkId.
                    'IsVipNetwork': False,# Is Load Balancer reception interface:True / False
                },
            ],
            NetworkVolume=10,
        )
        wait_for_multi_lb_create(
            client, MULTILB_NAME, MULTILB_WAIT_PORT, MULTILB_TARGET_PORT, MULTILB_PROTOCOL)

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
            ElasticLoadBalancerPort=MULTILB_WAIT_PORT,# Waiting Port.Can set range 1-65535
            InstancePort=MULTILB_TARGET_PORT,# Target Server Port.Can set range 1-65535
            Protocol=MULTILB_PROTOCOL, #LoadBalanceProtocol.Can be set 'TCP','UDP','HTTP' and 'HTTPS'
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
