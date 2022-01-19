from nifcloud import session
import sys


# -------- Show Resource ------------------------------

def parse_serviceStatus(statuslist):
    for status in statuslist:
        for key, value in status.items():
            if "Date" == key:
                print(f"{value}:")
            else:
                print(f"\t[{key}] : {value}")


def get_serviceStatus(client):
    try:
        result = client.describe_service_status(
            FromDate='20210301',  # Get Range Start
            ToDate='20210317',  # Get Range End
            # Format yyyymmdd,yyyy/mm/dd,yyy-mm-dd
        )
        print("RequestId :", result['RequestId'])
        parse_serviceStatus(result['ServiceStatusSet'])

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)

get_serviceStatus(client)
