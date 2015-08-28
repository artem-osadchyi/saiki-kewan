#!/usr/bin/env python3

import boto3
import requests
import sys
from optparse import OptionParser

parser = OptionParser()
parser.add_option("-f", "--file", type="string", dest="file", help="which config file should the host to be added on?")
parser.add_option("-d", "--data_dir", type="string", dest="data_dir", help="which is the data_dir?")

(options, args) = parser.parse_args()

# mandatory options
if options.file is None:   # if filename is not given
    parser.error('file not given')
    sys.exit(2)
else:
    config_file = options.file

if options.data_dir is None:   # if filename is not given
    parser.error('data_dir not given')
    sys.exit(2)
else:
    data_dir = options.data_dir

url = 'http://169.254.169.254/latest/dynamic/instance-identity/document'
try:
    response = requests.get(url)
    json = response.json()
    region = json['region']
    instanceId = json['instanceId']
    privateIp = json['privateIp']
    myid = privateIp.rsplit(".", 1)[1]

    autoscaling = boto3.client('autoscaling', region_name=region)
    ec2 = boto3.client('ec2', region_name=region)

    ec2_desc = ec2.describe_instances(InstanceIds=[instanceId])

    response = autoscaling.describe_auto_scaling_groups()
    autoscalingGroups = response['AutoScalingGroups']

    private_ips = []

    for autoscalingGroup in autoscalingGroups:
        found = False
        for instance in autoscalingGroup['Instances']:
            if instance['InstanceId'] == instanceId:
                found = True
        if found:
            for instance in autoscalingGroup['Instances']:
                private_ips.append(ec2.describe_instances(
                    InstanceIds=[instance['InstanceId']])['Reservations'][0]['Instances'][0]['PrivateIpAddress'])
            break

except requests.exceptions.ConnectionError:
    private_ips = ["127.0.0.1"]
    myid = "1"

for ip in private_ips:
    with open(config_file, mode='a', encoding='utf-8') as a_file:
        a_file.write('server.' + ip.rsplit(".", 1)[1] + '=' + ip + ':2888:3888\n')

with open(data_dir + "/myid", mode='w', encoding='utf-8') as a_file:
        a_file.write(myid)
