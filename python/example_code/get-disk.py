from nifcloud import session
import sys


# -------- Show Firewall --------------------------------------
def parse_attachmentSet(attachmentSet):
    for index, server in enumerate(attachmentSet):
        print("AttachServer[%03i] :" % index)
        for key in ["InstanceId",
                    "InstanceUniqueId",
                    "Status",
                    "AttachTime",
                    "Description",
                    ]:
            if key in server:
                print("\t%-16s : %s" % (key, server[key]))


def get_diskinfo(client):
    try:
        disks = client.describe_volumes()
        for disk in disks["VolumeSet"]:
            print("---------------------------------------")
            for key in ["VolumeId",
                        "Size",
                        "DiskType",
                        "Status",
                        "CreateTime",
                        "AccountingType",
                        "NextMonthAccountingType",
                        ]:
                if key in disk:
                    print(key, ":", disk[key])

            if "AttachmentSet" in disk:
                parse_attachmentSet(disk["AttachmentSet"])

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)

get_diskinfo(client)
