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
Prerequisites
* Your AWS Accounts needs to be prepared by the STUPS Team.
* You need to setup a Security Group which is named app-kewan (or similar to your app_id)
  * needs to reach itself on all ports
  * needs to be reach by outside via SSH / Port 22
* You need to setup a IAM Role which is named app-kewan (or similar to you app_id) for the App with the following grants:
  * Access to the Mint Bucket
  * EC2ReadOnlyAccess for finding out the other Nodes in the Cluster
* You must have registered your application in YourTurn/Kio, so it can access the Mint Bucket.

Then replace the variables in the template: kewan.yaml

Now create stack with senza use senza, like:
```
senza create kewan.yaml 1 0.1
```
Check the STUPS documention for additional options:
http://stups.readthedocs.org/en/latest/
