#!/bin/sh
# ref. https://github.com/wurstmeister/kafka-docker/blob/master/download-kafka.sh

mirror=$(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | sed -rn 's/.*"preferred":.*"(.*)"/\1/p')
echo $mirror
url="${mirror}zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz"
echo $url
wget -q "${url}" -O "/tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz"
echo done
