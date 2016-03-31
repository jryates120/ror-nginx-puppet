#!/bin/bash

set -e -x

LOGFILE=/var/log/$(hostname)-$(date +%m%d%y)-aws-puppet.log

export DEBIAN_FRONTEND=noninteractive

apt-get update >> $LOGFILE
apt-get -y upgrade >> $LOGFILE

puppet_master_ip=$(host ec2-54-200-183-80.us-west-2.compute.amazonaws.com | grep "has address" | head -1 | awk '{print $NF}')
echo $puppet_master_ip puppet >> /etc/hosts

aptitude -y install git
aptitude -y install puppet

git clone git://github.com/blt04/puppet-rvm.git /etc/puppet/modules/rvm >> $LOGFILE

git clone https://github.com/jryates120/ror-nginx-puppet.git /etc/puppet/manifests/ >> $LOGFILE

sed -i /etc/default/puppet -e 's/START=no/START=yes/'

service puppet restart

puppet apply --verbose /etc/puppet/manifests/ror-nginx-puppet/main.pp || tee -a $LOGFILE
