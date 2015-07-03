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

###### get our YAML File with the senza definition
```
wget https://raw.githubusercontent.com/zalando/saiki-kewan/master/kewan.yaml
```

###### execute senza with the definition file

```
senza create kewan.yaml <STACK_VERSION> <DOCKER_IMAGE_WITH_VERSION_TAG> <MINT_BUCKET> <SCALYR_LOGGING_KEY> <APPLICATION_ID>
```

An autoscaling group will be created and Kewan docker container will be running on all of the EC2 instances in this autoscaling group.

Check the STUPS documention for additional options:
http://stups.readthedocs.org/en/latest/
