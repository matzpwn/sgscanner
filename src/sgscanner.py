import json
import boto3
import os
from urllib import request
import sys


def lambda_handler(event, context):

    SLACK_URL = os.environ['SLACK_URL']
    SLACK_CHANNEL = os.environ['SLACK_CHANNEL']
    SLACK_USERNAME = os.environ['SLACK_USERNAME']
    TAG_EXCEPTION = os.environ['TAG_EXCEPTION']

    client = boto3.client('ec2')
    response = client.describe_security_groups()

    config = open("sg.config", "r")
    config_read = config.read()
    config_load = json.loads(config_read)

    slack_content = []
    for i in response['SecurityGroups']:
        try:
            SecurityGroupTags = i['Tags']
            TAG_EXCEPTION
            is_tag = True
        except (KeyError, NameError):
            is_tag = False
            pass
        SecurityGroupId = i['GroupId']        
        for j in i['IpPermissions']:
            for ip in j['IpRanges']:
                try:
                    this_port = j['FromPort']
                except KeyError:
                    continue
                for key in config_load:
                    this_ip = ip['CidrIp']
                    if key == this_ip:
                        cig = config_load[this_ip]
                        try:
                            if len(cig) > 0:
                                pass
                        except TypeError:
                            cig = [cig]
                        if this_port in cig:
                            sg_finding = "+ Found `%s:%s` in `%s`" % (
                                this_ip, this_port, SecurityGroupId)
                            if sg_finding not in slack_content:
                                if is_tag == True:
                                    ignore = False
                                    for tag in i['Tags']:
                                        SecurityGroupTagKey = tag['Key']
                                        SecurityGroupTagValue = tag['Value']
                                        exception = TAG_EXCEPTION.split(",")
                                        exception_key = exception[0]
                                        exception_value = exception[1]
                                        if SecurityGroupTagKey == exception_key:
                                            if SecurityGroupTagValue == exception_value:
                                                ignore = True
                                else:
                                    ignore = False
                                if ignore == False:
                                    slack_content.append(sg_finding)

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