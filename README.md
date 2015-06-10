Introduction
============
Kewan (javanese for animal) is Distributed ZooKeeper cluster appliance for AWS environment.

Kewan uses the recent release 3.4.6 version of ZooKeeper, this version can still not change the cluster membership without restarting.

So by deploying Kewan, it will take all the EC2 instances of one autoscaling group as ZooKeeper server nodes, with this list of nodes, the ZooKeeper config file ```zoo.cfg``` will be created at runtime.
