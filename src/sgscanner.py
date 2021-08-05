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
    defects = []

    for i in response['SecurityGroups']:
        SecurityGroupName = i['GroupName']
        for j in i['IpPermissions']:
            try:
                for k in j['IpRanges']:
                    if k['CidrIp'] == "0.0.0.0/0":
                        ifFound = True
                        if SecurityGroupName not in defects:
                            defects.append(SecurityGroupName)
            except Exception:
                continue

    if len(defects) > 0:
        this_sg = ",".join(defects)
        post = {
            "text": "`0.0.0.0/0` found in Security group `%s`" % (this_sg),
            "channel": SLACK_CHANNEL,
            "username": SLACK_USERNAME
        }

        json_data = json.dumps(post)
        req = request.Request(SLACK_URL,
                              data=json_data.encode('ascii'),
                              headers={'Content-Type': 'application/json'})
        request.urlopen(req)

    return {'statusCode': 200}