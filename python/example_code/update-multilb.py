from nifcloud import session
import sys

# --- define --------
# -- MULTILB Name -------
MULTILB_NAME = "web"
MULTILB_ID = "elb-000000000"
MULTILB_WAIT_PORT = 8080
MULTILB_TARGET_PORT = 80
MULTILB_PROTOCOL = 'HTTP'
# --------------------
# -------------------

# ----- Create Multi Load Balancer -----------------------


def wait_for_multi_lb_update(client, mlb_id, mlb_wait_port, mlb_target_port, mlb_protocol):
    print("wait : ", sys._getframe().f_code.co_name)
    try:
        waiter = client.get_waiter('elastic_load_balancer_available')
        wait_result = waiter.wait(
            ElasticLoadBalancers={
                'ListOfRequestElasticLoadBalancerId': [
                    mlb_id,
                ],
                'ListOfRequestElasticLoadBalancerPort': [
                    mlb_wait_port,
                ],
                'ListOfRequestInstancePort': [
                    mlb_target_port,
                ],
                'ListOfRequestProtocol': [
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


def update_multi_lb(client):
    try:
        # Update Load Balancer
        """
        client.nifty_update_elastic_load_balancer(
            ElasticLoadBalancerName='string', # Target Load Balancer Name.Exclusive Id
            ElasticLoadBalancerId='string', # Target Load Balander Id.Exclusive Name
            AccountingTypeUpdate=2,#1:Monthly
                                   #2:Payper(Default)
            ElasticLoadBalancerNameUpdate='string' # Name After change
            NetworkVolumeUpdate=10,# Max Network Traffic.
             # See also https://pfs.nifcloud.com/api/rest/NiftyCreateElasticLoadBalancer.htm
        )
        """
        client.nifty_update_elastic_load_balancer(
            ElasticLoadBalancerId=MULTILB_ID,
            #AccountingTypeUpdate=1,
            #ElasticLoadBalancerNameUpdate=MULTILB_NAME+"aft",
            NetworkVolumeUpdate=40,# Max Network Traffic.
        )
        wait_for_multi_lb_update(
            client, MULTILB_ID, MULTILB_WAIT_PORT, MULTILB_TARGET_PORT, MULTILB_PROTOCOL)


    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)


update_multi_lb(client)
