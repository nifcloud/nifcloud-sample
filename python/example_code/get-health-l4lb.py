from nifcloud import session
import sys

# --- define --------
# -- L4LB Name -------
L4LB_NAME = "web"
L4LB_WAIT_PORT = 80
L4LB_TARGET_PORT = 80
# --------------------
# -------------------

# ----- Get Server Health in  L4 Load Balancer -----------------------


def parse_describeInstanceHealthResult(result):
    for instance in result['InstanceStates']:
        print("%-16s :" % instance['InstanceId'])
        print("                  InstanceUniqueId :",
              instance["InstanceUniqueId"])
        print("                  State            :", instance["State"])
        print("                  State            :", instance["State"])


def get_serverhealth_l4lb(client):
    try:
        """
        status = client.describe_instance_health(
            # target LoadBrancer
            LoadBalancerName='string', #Load Balancer Name
            InstancePort=123, # Target Server Port
            LoadBalancerPort=123, # Waiting Port(Exclusive Protocol)
            # Tareget Server List
            Instances=[
                { 'InstanceId': 'string' },
                { 'InstanceId': 'string' },
            ],
        )
        """
        status = client.describe_instance_health(
            # target LoadBrancer
            LoadBalancerName=L4LB_NAME,  # Load Balancer Name
            InstancePort=L4LB_TARGET_PORT,  # Target Server Port
            # Waiting Port(Exclusive Protocol)
            LoadBalancerPort=L4LB_WAIT_PORT
        )
        parse_describeInstanceHealthResult(
            status["DescribeInstanceHealthResult"])

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)


get_serverhealth_l4lb(client)
