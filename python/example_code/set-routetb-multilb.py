from nifcloud import session
import sys

# --- define --------
# -- MULTILB Name -------
MULTILB_NAME = "web"
MULTILB_WAIT_PORT = 8080
MULTILB_TARGET_PORT = 80
MULTILB_PROTOCOL = 'HTTP'
# --------------------
# -- Routing Info --------
TARGET_CIDER = '10.2.3.0/24'
TARGET_NEXTHOP = '10.4.4.1'
# --------------------
# -------------------

# ----- Add Route Table Multi Load Balancer ----------------


def create_multi_lb(client):
    try:
        # Create Route Table
        route_table = client.create_route_table()

        # add Routing Info
        """
                  ┃                              
              ┏━┻━━┓                        
              ┃MultiLB ┃                        
              ┗━┳━━┛                        
          ┏━━━┻━━━━┓                    
          ┃                ┃                    
      IpAddress         ┏━┻━━━━━━━━━┓
┏━━━━━━━━━━┓┃Network               ┃
┃DestinationCidrBlock┃┃(DestinationCidrBlock)┃
┗━━━━━━━━━━┛┗━━━━━━━━━━━┛
        client.create_route(
            # Target RouteTable
            RouteTableId='string',
            # Destination IP Range(CIDR)
            DestinationCidrBlock='string',
            # Set either NetworkName or NetworkId or IpAddress
            # Next Hop Ipaddress
            IpAddress='string',
            # Target Private LAN ID
            NetworkId='string',
            # Target Private LAN Name
            NetworkName='string',
        )
        """
        result = client.create_route(
            # Target RouteTable
            RouteTableId=route_table['RouteTable']['RouteTableId'],
            # Destination IP Range(CIDR)
            DestinationCidrBlock=TARGET_CIDER,
            # Set either NetworkName or NetworkId or IpAddress
            # Next Hop Ipaddress
            IpAddress=TARGET_NEXTHOP,
        )
        if not result['Return']:
            print("Add Route Error")
            sys.exit(1)

        # Get Multl Load Balancer ID
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

        mlb_id = \
            mlb['NiftyDescribeElasticLoadBalancersResult']['ElasticLoadBalancerDescriptions'][0]['ElasticLoadBalancerId']
        # Set Route Table
        result = \
            client.nifty_associate_route_table_with_elastic_load_balancer(
                ElasticLoadBalancerId=mlb_id,
                RouteTableId=route_table['RouteTable']['RouteTableId'],
            )
        if not result['Return']:
            print("Set Route Table Error")
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
