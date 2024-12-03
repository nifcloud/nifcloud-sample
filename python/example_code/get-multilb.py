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

# ----- Create Multi Load Balancer -----------------------


def parse_networkInterfaceSet(networkInterfaceSet):
    for index, networkinterface in enumerate(networkInterfaceSet):
        print("Interface[%03i] :" % index)
        # --- connect Network name -----------
        networkname = ""
        if networkinterface["NetworkId"] in \
           ["net-COMMON_GLOBAL", "net-COMMON_PRIVATE", "net-MULTI_IP_ADDRESS"]:
            networkname = {"net-COMMON_GLOBAL": "Common-Global",
                           "net-COMMON_PRIVATE": "Common-Private",
                           "net-MULTI_IP_ADDRESS": "Use Multi IP"}[networkinterface["NetworkId"]]
        else:
            networkname = networkinterface["NetworkName"]
        print("\tNetworkName  :", networkname)
        print("\tDescription  :", networkinterface['Description'])
        print("\tIPAddress    :", networkinterface['IpAddress'])
        print("\tIsVipNetwork :", networkinterface['IsVipNetwork'])


def parse_expectation(expectations):
    code = []
    for expectation in expectations:
        code.append(str(expectation['HttpCode']))
    print(f"\t\tExpectation : {','.join(code)}")


def parse_instanceStates(instanceStates):
    for index, status in enumerate(instanceStates):
        print("\t\tInstanceStates[%04i]:" % index)
        for k, v in status.items():
            print(f"\t\t\t{k} : {v}")


def parse_instances(instances):
    for index, instance in enumerate(instances):
        print("\t\t\tInstance[%04i]:" % index)
        for k, v in instance.items():
            print(f"\t\t\t\t{k} : {v}")


def parse_sorryPage(sorrypage):
    print("\t\tSorryPage :")
    for k, v in sorrypage.items():
        print(f"\t\t\t{k} : {v}")


def parse_healthCheck(helthcheck):
    print("\t\tHealthCheck:")
    for k, v in helthcheck.items():
        if k == "Expectation":
            parse_expectation(v)
        elif k == "InstanceStates":
            parse_instanceStates(v)
        else:
            print(f"\t\t\t{k} : {v}")


def parse_elasticLoadBalancerListenerDescriptions(listers):
    for index, lister in enumerate(listers):
        print("\tListener[%04i]:" % index)
        for k, v in lister['Listener'].items():
            if k == 'HealthCheck':
                parse_healthCheck(v)
            elif k == 'Instances':
                parse_instances(v)
            elif k == 'SorryPage':
                parse_sorryPage(v)
            elif k == 'SessionStickinessPolicy':
                print(f"\t\tSessionStickinessPolicy : {v['Enabled']}")
            else:
                print(f"\t\t{k} : {v}")


def parse_versionInformation(version):
    print("Version:")
    for k, v in version.items():
        print(f"\t{k} : {v}")


def parse_niftyDescribeElasticLoadBalancersResult(result):
    for mlb in result['ElasticLoadBalancerDescriptions']:
        for key in ["ElasticLoadBalancerName",
                    "ElasticLoadBalancerId",
                    "DNSName",
                    "State",
                    "NetworkVolume",
                    "AccountingType",
                    "NextMonthAccountingType",
                    "AvailabilityZones",
                    "CreatedTime",
                    "ElasticLoadBalancerListenerDescriptions",
                    "NetworkInterfaces",
                    "RouteTableAssociationId",
                    "RouteTableId",
                    "VersionInformation", ]:
            if key == 'NetworkInterfaces':
                parse_networkInterfaceSet(mlb[key])
            elif key == 'ElasticLoadBalancerListenerDescriptions':
                parse_elasticLoadBalancerListenerDescriptions(mlb[key])
            elif key == 'VersionInformation':
                parse_versionInformation(mlb[key])
            else:
                if key in \
                   ["RouteTableAssociationId", "RouteTableId"] and \
                   ("RouteTableAssociationId" not in mlb or 
                    "RouteTableId" not in mlb):
                    continue
                print(f"{key} : {mlb[key]}")

def get_multi_lb(client):
    try:
        # Get Multl Load Balancer
        """
        response = client.nifty_describe_elastic_load_balancers(
            ElasticLoadBalancers={
                # Load Balancer Id(Exclusive Name)
                'ListOfRequestElasticLoadBalancerId': [
                    'string',
                ],
                # Load Balancer Name(Exclusive Id)
                'ListOfRequestElasticLoadBalancerName': [
                    'string',
                ],
                # Waiting Port.Can set range 1-65535
                'ListOfRequestElasticLoadBalancerPort': [
                    123,
                ],
                # Target Server Port.Can set range 1-65535
                'ListOfRequestInstancePort': [
                    123,
                ],
                #LoadBalanceProtocol.
                'ListOfRequestProtocol': [
                    'TCP'|'UDP'|'HTTP'|'HTTPS',
                ]
            },
            # Search Filter
            # https://docs.nifcloud.com/cp/api/NiftyDescribeElasticLoadBalancers.htm
            Filter=[
                {
                    'ListOfRequestValue': [
                        'string',
                    ],
                    'Name': 'availability-zone'|'state'|'elastic-loadbalancer-id'|
                            'elastic-loadbalancer-name'|'description'|
                            'accounting-type'|'ip-address'|'version',
                },
            ]
        )
        """
        # get for all multl load balancer
        response = client.nifty_describe_elastic_load_balancers()
        parse_niftyDescribeElasticLoadBalancersResult(
            response['NiftyDescribeElasticLoadBalancersResult'])

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)


get_multi_lb(client)
