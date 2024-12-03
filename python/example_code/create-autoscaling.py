from nifcloud import session
import sys

# ---- define name -------
AUTOSCALE_NAME='autoscale'
MASTER_IMAGE_ID = "99999"
FW_NAME = 'webfw'
LB_NAME = 'web'
LB_TARGET_PORT = 80
LB_WAIT_PORT = 80
# -------------------------


# ------ Create Virtual Server ----------------------------------

def create_autoscaling(client):
    try:
        """
        response = client.nifty_create_auto_scaling_group(
            # Config Name
            AutoScalingGroupName='string',
            # memo
            Description='string',
            # Scaleout Unit. 1-5
            ChangeInCapacity=1,
            # Degeneracy start interval.(in sec)
            # Range 600-36000(300step).(Default 1800)
            DefaultCooldown=1800,
            # Base Image Id
            ImageId='string',
            # Scaleout Instance Life Time(in sec)
            # Range 1800-36000(1800step).Default 1800
            InstanceLifecycleLimit=1800,
            #Server Type.Default 'mini'
            #see also https://docs.nifcloud.com/cp/api/RunInstances.htm
            InstanceType="mini",
            # Min Instance count.
            # Range 1-(MaxSize-1)
            MinSize=1,
            # Max Instance count
            # Range MinSize-20
            MaxSize=20,
            # Time to scale-out after meeting the conditions
            # Set to 0(Default),600,1200,1800
            Scaleout=0,
            # -----------------------------------------
            # LoadBalancer to incorporate
            LoadBalancers=[
                {
                    # Load Balancer Name
                    'Name': 'string',
                    # Target Server Port
                    'InstancePort': 123,
                    # Load Balancer Waiting Port
                    'LoadBalancerPort': 123,
                },
            ],
            # ---------------------------------------------
            # Multipul Scaling Trigger Condition
            # or : at lieast one
            # and : request all
            ScaleoutCondition='or'|'and',
            # Scaling Torigger Cndition
            ScalingTrigger=[
                {
                    # Check Resource
                    # 'Server-cpu'|'Server-memory'|
                    # 'Server-network'|'LoadBalancer-network',
                    'Resource': 'string',
                    # Limit value
                    # Range: 0-100(%) at cpu,memory
                    # Range: 0-1048576(Mbps) at network
                    'UpperThreshold': 10,
                    # Period threshold for Upper Threshold.at sec
                    # Set to 600(default),1200,1800
                    'BreachDuration': 600,
                },
            ],
            # ---------------------------------------------
            # Scaling Enable Scledule
            ScalingSchedule=[
                {
                    # Enable Month Range
                    'RequestMonth': {
                        # Range 1(default) - 12
                        'StartingMonth': '1',
                        # Range StartingMonth - 12(default)
                        'EndingMonth': '12',
                    },
                    # Enable Day Range
                    'RequestDDay': {
                        # Range 1(default)-31
                        'StartingDDay': '1',
                        # Default 31
                        'EndingDDay': '31',
                    },
                    # Enable Hower Range
                    'RequestTimeZone': {
                        # Range 0(default)-23
                        'StartingTimeZone': '0',
                        # Range StartingTimeZone - 24(default)
                        'EndingTimeZone': '24',
                    },
                    # Config Enable Day
                    # 0:Disable(Default)
                    # 1:Enable
                    'RequestDay': {
                        'SetMonday': '0',
                        'SetThursday': '0',
                        'SetWednesday': '0',
                        'SetTuesday': '0',
                        'SetFriday': '0',
                        'SetSaturday': '0',
                        'SetSunday': '0',
                    },
                },
            ],
            #Firewall Group name
            SecurityGroup=[
                'string',
            ]
        )
        """
        result = client.nifty_create_auto_scaling_group(
            AutoScalingGroupName=AUTOSCALE_NAME,
            Description='memo',
            ChangeInCapacity=1,
            DefaultCooldown=600,
            ImageId=MASTER_IMAGE_ID,
            InstanceLifecycleLimit=1800,
            InstanceType="mini",
            MinSize=1,
            MaxSize=20,
            Scaleout=0,
            # -----------------------------------
            LoadBalancers=[
                {
                    'Name': LB_NAME,
                    'InstancePort': LB_TARGET_PORT,
                    'LoadBalancerPort': LB_WAIT_PORT,
                },
            ],
            # -----------------------------------
            ScaleoutCondition='or',
            ScalingTrigger=[
                {
                    'Resource': 'Server-cpu',
                    'UpperThreshold': 50,
                    'BreachDuration': 600,
                },
                {
                    'Resource': 'Server-memory',
                    'UpperThreshold': 50,
                    'BreachDuration': 600,
                },
            ],
            ScalingSchedule=[
                {
                    'RequestMonth': {
                        'StartingMonth': '1',
                        'EndingMonth': '6',
                    },
                    'RequestDDay': {
                        'StartingDDay': '1',
                        'EndingDDay': '31',
                    },
                    'RequestTimeZone': {
                        'StartingTimeZone': '0',
                        'EndingTimeZone': '24',
                    },
                    'RequestDay': {
                        'SetMonday': '1',
                        'SetThursday': '0',
                        'SetWednesday': '1',
                        'SetTuesday': '0',
                        'SetFriday': '1',
                        'SetSaturday': '0',
                        'SetSunday': '1',
                    },
                },
                {
                    'RequestMonth': {
                        'StartingMonth': '7',
                        'EndingMonth': '12',
                    },
                    'RequestDDay': {
                        'StartingDDay': '1',
                        'EndingDDay': '31',
                    },
                    'RequestTimeZone': {
                        'StartingTimeZone': '0',
                        'EndingTimeZone': '24',
                    },
                    'RequestDay': {
                        'SetMonday': '0',
                        'SetThursday': '1',
                        'SetWednesday': '0',
                        'SetTuesday': '1',
                        'SetFriday': '0',
                        'SetSaturday': '1',
                        'SetSunday': '0',
                    },
                },
            ],
            SecurityGroup=[
                FW_NAME,
            ]
        )
        if not result['Return']:
            print("Create Autoscale Config")
            sys.exit(1)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)
create_autoscaling(client)
