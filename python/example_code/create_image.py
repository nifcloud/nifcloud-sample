from nifcloud import session
import sys
import time


# -- Define -----------
DST_IMG_NAME = 'webimg'
SRC_INSTANCE_NAME = 'web001'
# --------------------


def create_image(client):
    try:
        """
        disks = client.create_image(
                    Name='string',#Image Name
                    Description='string',#memo
                    InstanceId='string',#Source Instance
                    LeftInstance=True,#True :leave image
                                      #False:no leave image
                    Placement={#Target zone
                        'AvailabilityZone': 'string', #Zone Name.
                             #For jp-east-1, east-11,east-12,east-13,east-14 can be selected.
                             #For jp-west-1, west-11,west-12,west-13 can be selected.
                        'RegionName': 'string'# Get from DescribeRegions API
                    }
                )
        """
        image_info = client.create_image(
            Name=DST_IMG_NAME,  # Image Name
            Description='memo',  # memo
            InstanceId=SRC_INSTANCE_NAME,  # Source Instance
            LeftInstance=True,  # True :leave image
            Placement={  # Target Zone
                'AvailabilityZone': 'east-11',  # Zone Name.
                'RegionName': 'east-1'
            }
        )
        print(image_info)
        if image_info["ImageState"] == "pending":
            while True:
                save_status = client.describe_images(
                    ImageId=[image_info['ImageId']]
                )
                if save_status["ImagesSet"][0]["ImageState"] == "available":
                    print("image conversion complite!!")
                    break
                print("Imaging... Wait for 20sec")
                time.sleep(20)

    except Exception as e:
        print("exception :", e, "\nin :", sys._getframe().f_code.co_name)
        sys.exit(1)


# -------------- main ----------------
client = session.get_session().create_client(
    "computing",
    region_name="jp-east-2",
)

create_image(client)
