from nifcloud import session
import sys


# -------- Show Usage ------------------------------


def parse_usage(usage_key, usage_value):
    print(f"{usage_key} :")
    if not isinstance(usage_value, list):
        usage_value = [usage_value]
    for usage in usage_value:
        if 'Type' in usage:
            print(f"\t{usage['Type']} :")
        for key, value in usage.items():
            if 'Type' != key:
                print(f"\t\t{key} : {value}")


def get_usage(client,reagin):
    print(f"------------ {reagin} -----------------")
    try:
        """
        resouces = client.describe_usage(
            IsCharge=False, # Display Cost
                            # True:Display
                            # False:Not Display
            Region='string',# Reagion
            YearMonth='string'# Target Month
        )
        """
        resouces = client.describe_usage(
            IsCharge=True,  # Display Cost
            YearMonth='202012',  # Target Month
            Region=reagin,# Reagion
        )
        for key, value in resouces.items():
            if key in ["YearMonth", "RequestId"]:
                print(f"{key} : {value}")
            elif "ResponseMetadata" == key:
                continue
            else:
                if len(value) <= 0:
                    continue
                for usage_key, usage_value in value.items():
                    parse_usage(usage_key, usage_value)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-1",
)

get_usage(client,"east-1")
get_usage(client,"east-2")
get_usage(client,"east-3")
get_usage(client,"jp-east-4")
get_usage(client,"west-1")
