from nifcloud import session
import sys

# ---- define name -------
AUTOSCALE_NAME='autoscale'
# ------------------------

# -------- Show Scaleout Log --------------------------


def parse_log(logs):
    for log in logs:
        print("Process:",log["Process"])
        print("\tDate :",log["Time"])
        for key, value in log['Details'].items():
            print(f"\t{key} : {value}")


def get_scaleoutlog(client):
    try:
        """
        response = client.nifty_describe_scaling_activities(
            # Target Autoscaling Name
            AutoScalingGroupName='string',
            # Log Range.Format yyyymmdd,yyyy-mm-dd and yyyy/mm/dd
            ActivityDateFrom='string',
            ActivityDateTo='string',
            Range={
                # All log get
                # True: All log get
                # False: not All.Request paramator.(Default)
                'All': False,
                # --- if "All:False" then set paramator at under  -----
                # Get Range Start
                # Range (NEW)1(default) - max log number
                'StartNumber': 123,
                # Get Range 
                # Range max log number.default 100
                'EndNumber': 100,# Get Range End
            }
        )
        """
        logs = client.nifty_describe_scaling_activities(
            # Target Autoscaling Name
            AutoScalingGroupName=AUTOSCALE_NAME,
            # Log Range.Format yyyymmdd,yyyy-mm-dd and yyyy/mm/dd
            ActivityDateFrom='2021/01/27',
            ActivityDateTo='2021/01/27',
            Range={
                'All': False,
                'StartNumber': 1,
                'EndNumber': 200,
            }
        )
        for key, value in logs.items():
            if key in ["RequestId","AutoScalingGroupName"]:
                print(f"{key} : {value}")
            elif "ResponseMetadata" == key:
                continue
            elif "LogSet" == key:
                parse_log(value)
            else:
                print("Not Parse")
                print(f"{key} : {value}")

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)

get_scaleoutlog(client)
