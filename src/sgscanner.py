import json
import boto3
import os
from urllib import request


def lambda_handler(event, context):

    SLACK_URL = os.environ['SLACK_URL']
    SLACK_CHANNEL = os.environ['SLACK_CHANNEL']
    SLACK_USERNAME = os.environ['SLACK_USERNAME']

    client = boto3.client('ec2')
    response = client.describe_security_groups()

    config = open("sg.config", "r")
    config_read = config.read()
    config_load = json.loads(config_read)

    slack_content = []
    for i in response['SecurityGroups']:
        SecurityGroupId = i['GroupId']
        for j in i['IpPermissions']:
            try:
                this_ip = j['IpRanges'][0]['CidrIp']
                this_port = j['FromPort']
                for key in config_load:
                    if key == this_ip:
                        if this_port in config_load[this_ip]:
                            sg_finding = "+ Found `%s:%s` in `%s`" % (
                                this_ip, this_port, SecurityGroupId)
                            if sg_finding not in slack_content:
                                slack_content.append(sg_finding)
            except:
                pass

    if len(slack_content) > 0:
        slack_content = "".join(slack_content)
        post = {
            "text": slack_content,
            "channel": SLACK_CHANNEL,
            "username": SLACK_USERNAME
        }

        json_data = json.dumps(post)
        req = request.Request(SLACK_URL,
                              data=json_data.encode('ascii'),
                              headers={'Content-Type': 'application/json'})
        request.urlopen(req)

    return {'statusCode': 200}
