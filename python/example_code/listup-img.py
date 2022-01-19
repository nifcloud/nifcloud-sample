from nifcloud import session
import re

client = session.get_session().create_client(
    "computing",
    region_name="jp-east-1",
)

imagelist = client.describe_images()
for image in imagelist['ImagesSet']:
    imagename = re.sub("[ .+]", "_", image['Name'])
    # limit 32 str
    imagename = re.sub("Windows", "Win", imagename)
    imagename = re.sub("Server", "Sev", imagename)
    print("data \"nifcloud_image\" \"%s\" {" % imagename)
    print("\timage_name = \"%s\"" % image['Name'])
    print("\timage_id = \"%s\"" % image['ImageId'])
    print("}")
    print()
