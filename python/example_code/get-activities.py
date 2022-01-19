from nifcloud import session
import sys


# -------- Show Activities ------------------------------


def parse_activities(activiti_list):
    for activiti in activiti_list:
        print("Date :",activiti["DateTime"])
        for key, value in activiti.items():
            if "DateTime" == key:
                continue
            print(f"\t{key} : {value}")


def get_activities(client):
    try:
        """
        response = client.describe_user_activities(
            Range={
                'StartNumber': 123, # Get Range Start
                'EndNumber': 123, # Get Range End
            },
            YearMonth='string'# Target Month
            # yyyy-mm or yyyy/mm or yyyymm
        )
        """
        resouces = client.describe_user_activities(
            YearMonth='202012',  # Target Month
            Range={
                'StartNumber':1,
                'EndNumber':100,
            }
        )
        for key, value in resouces.items():
            if key in ["RequestId"]:
                print(f"{key} : {value}")
            elif "ResponseMetadata" == key:
                continue
            else:
                parse_activities(value)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-1",
)

get_activities(client)
