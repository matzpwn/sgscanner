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
    a = config.read()
    b = json.loads(a)

    sg_ports = []
    sg_ids = []
    sg_ips = []
    for i in response['SecurityGroups']:
        SecurityGroupId = i['GroupId']
        for j in i['IpPermissions']:
            try:
                for d in b:
                    theport = b[d]
                    if type(theport) == int:
                        thisport = []
                        thisport.append(theport)
                    else:
                        thisport = theport
                    if j['IpRanges'][0]['CidrIp'] == d:
                        if j['FromPort'] in thisport:
                            if j['FromPort'] not in sg_ports:
                                sg_ids.append(SecurityGroupId)
                                sg_ports.append(j['FromPort'])
                                sg_ips.append(d)
            except IndexError:
                pass

    slack_content = []
    x = 0
    for finding in sg_ports:
        if x == len(sg_ports)-1:
            slack_content.append("+ Found `%s:%s` in `%s`" %
                                 (sg_ips[x], sg_ports[x], sg_ids[x]))
        else:
            slack_content.append("+ Found `%s:%s` in `%s`\n" %
                                 (sg_ips[x], sg_ports[x], sg_ids[x]))
        x = x + 1

    if len(sg_ids) > 0:
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