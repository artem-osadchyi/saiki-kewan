Introduction
============
Kewan (javanese for animal) is a Distributed ZooKeeper cluster appliance for AWS environment.

Kewan uses the recent release 3.4.6 version of ZooKeeper, this version can still not change the cluster membership without restarting.

So by deploying Kewan, it will take all the EC2 instances of one autoscaling group as ZooKeeper server nodes, with this list of nodes, the ZooKeeper config file ```zoo.cfg``` will be created at runtime.

Usage
=====
Create an autoscaling group in AWS, and on each instance of this autoscaling group, after building the docker image, start Kewan like this:
```
sudo docker run -p 2181:2181 -p 2888:2888 -p 3888:3888 -d --net=host <IMAGE_ID>
```
Docker run option ```--net=host``` is needed, so zookeeper can bind the interface from the host, to listen for leader elections. Ref. https://docs.docker.com/articles/networking/#how-docker-networks-a-container

Deployment with STUPS toolbox
-----------------------------

###### Create the docker and push

Push your docker image to STUPS ```PierOne```, see here: http://stups.readthedocs.org/en/latest/user-guide/deployment.html#prepare-the-deployment-artifact

###### Register the Kewan app in Yourturn/Kio

Docs: http://docs.stups.io/en/latest/components/yourturn.html

if needed, you need to adjust later in the yaml-file the Stackname or the application_id to suit the one you have put in Yourturn/Kio

###### Create the Security group for Kewan
this is assuming that you have installed and configured JQ and the AWS CLI!

```
SEC_GROUP=$(aws ec2 create-security-group --group-name app-kewan --description "Kewan Appliance Security Group" | jq -r '.GroupId')
aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP --protocol tcp --port 3888 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP --protocol tcp --port 2888 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP --protocol tcp --port 2181 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SEC_GROUP --protocol tcp --port 22 --cidr 0.0.0.0/0
```
adjust the group name to your needs, but then you need to adjust it later in the yaml file, too ...

###### get our YAML File with the senza definition
```
wget https://raw.githubusercontent.com/zalando/saiki-kewan/master/kewan.yaml
```

###### execute senza with the definition file

```
senza create kewan.yaml <STACK_VERSION> <DOCKER_VERSION> <DOCKER_IMAGE> <MINT_BUCKET> <SCALYR_LOGGING_KEY>
```

An autoscaling group will be created and Kewan docker container will be running on all of the EC2 instances in this autoscaling group.

Check the STUPS documention for additional options:
http://stups.readthedocs.org/en/latest/
