#!/bin/sh

echo "checking for other nodes ..."
python3 /tmp/find_out_other_zk_hosts.py -f /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg -d /var/zookeeper
echo "edited other nodes into config"

echo "starting Zookeeper now ..."
/opt/zookeeper-${ZOOKEEPER_VERSION}/bin/zkServer.sh start-foreground
