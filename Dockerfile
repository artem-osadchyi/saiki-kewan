FROM zalando/python:3.4.0-1
MAINTAINER fabian.wollert@zalando.de teng.qiu@zalando.de

ENV ZOOKEEPER_VERSION="3.4.6"

RUN apt-get update
RUN apt-get install wget openjdk-7-jre -y --force-yes
RUN pip3 install boto3

ADD download_zookeeper.sh /tmp/download_zookeeper.sh
RUN chmod u+x /tmp/download_zookeeper.sh

RUN /tmp/download_zookeeper.sh
RUN tar xf /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C /opt

ADD zoo.cfg /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg
RUN chmod 666 /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg

ADD find_out_other_zk_hosts.py /tmp/find_out_other_zk_hosts.py
RUN mkdir -p /var/zookeeper
RUN chmod -R 777 /var/zookeeper

ADD adapt_config_and_start.sh /tmp/adapt_config_and_start.sh
RUN chmod 777 /tmp/adapt_config_and_start.sh
CMD /tmp/adapt_config_and_start.sh

EXPOSE 2181 2888 3888
