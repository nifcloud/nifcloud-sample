from nifcloud import session
import sys

# ---- define name -------
AUTOSCALE_NAME='autoscale'
# ------------------------

# -------- Create Alerm --------------------------


def parse_log(logs):
    for log in logs:
        print("Process:",log["Process"])
        print("\tDate :",log["Time"])
        for key, value in log['Details'].items():
            print(f"\t{key} : {value}")


def get_scaleoutlog(client):
    try:
        """
        response = client.nifty_create_alarm(
            # Rule Name
            RuleName='string',
            # memo
            Description='string',
            # ----- Alerm Condition ------
            # Target infla Resource
            FunctionName='Server'|'LoadBalancer'|'DiskPartition'|'ElasticLoadBalancer',
            # Alerm Rule
            Rule=[
                {
                    # Time to alerm after meeting the condition
                    # Can set 10,20 or 30
                    'BreachDuration': 10,
                    # Target Datatype
                    #  cpu:cpu usage
                    #  memory:memory usage
                    #  volume:disk usage
                    #  ping:ping result
                    #  status:server status(on/off)
                    #  networkPort:traffic per port
                    #  networkAll:traffic for the entire loadbalancer
                    #  partition:partiton usage
                    # if FunctionName is Server
                    # Can Use 'cpu','memory','volume','ping','status'
                    # if FunctionName is LoadBalancer or ElasticLoadBalancer
                    # Can Use 'networkPort','networkAll'
                    # if FunctionName is DiskPartition
                    # Can Use 'partition'
                    'DataType': 'string',
                    # if DataType do not have set ping or statsu
                    # set specify. unit is %
                    'Threshold': 100,
                    # if DataType do set server set specify.
                    # Threshold upper or lower
                    'UpperLowerCondition': 'upper'|'lower'
                },
            ],
            # Alerm Send Target email
            EmailAddress=[
                'example@example.com',
            ],
            # ---- FunctionName is not LoadBalancer ----
            # Target Zone
            Zone='string',
            # ---- FunctionName is Server or Partition --
            # Target Server Name
            InstanceId=[
                'string',
            ],
            # ---------------------------
            # Multipul Alerm Trigger Condition
            # or : at lieast one
            # and : request all
            AlarmCondition='and'|'or',
            # ---- FunctionName is Partition --
            # Target partition Name
            # if target set all partiton set 'all'
            Partition=[
                'string',
            ],
            # ---- FunctionName is ElasticLoadBalancer --
            # Target Multi LoadBalaner Name
            ElasticLoadBalancerName=[
                'string',
            ],
            # Target Multi LoadBalaner Wait Port
            # range 1 - 65535
            ElasticLoadBalancerPort=[
                123,
            ],
            # Target Multi LoadBalaner Protocol
            # 'TCP','UDP','HTTP','HTTPS'
            ElasticLoadBalancerProtocol=[
                'string',
            ],
            # ---- FunctionName is LoadBalancer --
            # Target L4LoadBalancer Name
            LoadBalancerName=[
                'string',
            ],
            # Target L4LoadBalancer Wait Port
            LoadBalancerPort=[
                123,
            ],
        )
        """
        # Server Status
        response = client.nifty_create_alarm(
            RuleName='serveralerm',
            Description='memo',
            FunctionName='Server',
            Rule=[
                {
                    'BreachDuration': 10,
                    'DataType': 'cpu',
                    'Threshold': 50,
                    'UpperLowerCondition': 'upper'
                },
                {
                    'BreachDuration': 10,
                    'DataType': 'memory',
                    'Threshold': 50,
                    'UpperLowerCondition': 'upper'
                },
                {
                    'BreachDuration': 10,
                    'DataType': 'ping',
                },
                {
                    'BreachDuration': 10,
                    'DataType': 'status',
                },
            ],
            EmailAddress=[
                'example@example.com',
            ],
            Zone='east-21',
            InstanceId=[
                'web001',
                'web002',
            ],
            AlarmCondition='and',
        )
        if response['Return']:
            print("Server Alerm Create")
        else:
            print("Server Alerm Create Fail")

        # partiton usage
        response = client.nifty_create_alarm(
            RuleName='partitionalerm',
            Description='memo',
            FunctionName='DiskPartition',
            Rule=[
                {
                    'BreachDuration': 10,
                    'DataType': 'partition',
                    'Threshold': 50,
                    'UpperLowerCondition': 'upper',
                },
            ],
            EmailAddress=[
                'example@example.com',
            ],
            Zone='east-21',
            InstanceId=[
                'web001',
            ],
            Partition=[
                'all',
            ],
        )
        if response['Return']:
            print("Partition Alerm Create")
        else:
            print("Partition Alerm Create Fail")

        # LoadBalancer Traffic
        response = client.nifty_create_alarm(
            RuleName='l4lbalert',
            Description='memo',
            FunctionName='LoadBalancer',
            Rule=[
                {
                    'BreachDuration': 10,
                    'DataType': 'networkPort',
                    'Threshold': 50,
                    'UpperLowerCondition': 'upper',
                },
            ],
            EmailAddress=[
                'example@example.com',
            ],
            LoadBalancerName=[
                'web',
            ],
            LoadBalancerPort=[
                80,
            ],
        )
        if response['Return']:
            print("L4LB Alerm Create")
        else:
            print("L4LB Alerm Create Fail")

        # Multi LoadBalancer Traffic
        response = client.nifty_create_alarm(
            RuleName='multilb',
            Description='memo',
            FunctionName='ElasticLoadBalancer',
            Rule=[
                {
                    'BreachDuration': 10,
                    'DataType': 'networkPort',
                    'Threshold': 50,
                    'UpperLowerCondition': 'upper',
                },
            ],
            EmailAddress=[
                'example@example.com',
            ],
            Zone='east-21',
            ElasticLoadBalancerName=[
                'web',
            ],
            ElasticLoadBalancerPort=[
                8080,
            ],
            ElasticLoadBalancerProtocol=[
                'HTTP',
            ],
        )
        if response['Return']:
            print("MLB Alerm Create")
        else:
            print("MLB Alerm Create Fail")

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)

get_scaleoutlog(client)
