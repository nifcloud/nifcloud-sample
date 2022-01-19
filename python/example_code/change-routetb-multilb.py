from nifcloud import session
import sys

# --- define --------
# -- MULTILB Name -------
MULTILB_NAME = "web"
MULTILB_WAIT_PORT = 8080
MULTILB_TARGET_PORT = 80
MULTILB_PROTOCOL = 'HTTP'
# -------------------

# ----- Replace Route Table for Multi Load Balancer -------------


def create_multi_lb(client):
    try:
        # Create Route Table
        route_table = client.create_route_table()

        # add Routing Info
        result = client.create_route(
            # Target RouteTable
            RouteTableId=route_table['RouteTable']['RouteTableId'],
            # Destination IP Range(CIDR)
            DestinationCidrBlock="10.10.0.0/24",
            # Set either NetworkName or NetworkId or IpAddress
            # Next Hop Ipaddress
            IpAddress='10.0.0.20',
        )
        if not result['Return']:
            print("Add Route Error")
            sys.exit(1)

        # Get Multl Load Balancer Infomation
        mlb = client.nifty_describe_elastic_load_balancers(
            ElasticLoadBalancers={
                'ListOfRequestElasticLoadBalancerName': [
                    MULTILB_NAME,
                ],
                'ListOfRequestElasticLoadBalancerPort': [
                    MULTILB_WAIT_PORT,
                ],
                'ListOfRequestInstancePort': [
                    MULTILB_TARGET_PORT,
                ],
                'ListOfRequestProtocol': [
                    MULTILB_PROTOCOL,
                ]
            }
        )

        # Get from nifty_describe_elastic_load_balancers API
        mlb_route_asoc_id = \
            mlb['NiftyDescribeElasticLoadBalancersResult']['ElasticLoadBalancerDescriptions'][0]['RouteTableAssociationId']
        # Set Route Table
        result = \
            client.nifty_replace_route_table_association_with_elastic_load_balancer(
                AssociationId=mlb_route_asoc_id,
                RouteTableId=route_table['RouteTable']['RouteTableId'],
            )
        if not result['Return']:
            print("Replace Route Table Error")
            sys.exit(1)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)


create_multi_lb(client)
