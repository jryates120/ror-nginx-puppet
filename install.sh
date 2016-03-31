#!/bin/bash

set -e -x

cd $HOME

LOGFILE=$(hostname)-$(date +%m%d%y)-puppet.log

export DEBIAN_FRONTEND=noninteractive

apt-get update >> $LOGFILE
apt-get install git >> $LOGFILE
apt-get -y upgrade >> $LOGFILE

puppet_master_ip=$(host ec2-54-200-183-80.us-west-2.compute.amazonaws.com | grep "has address" | head -1 | awk '{print $NF}')
echo $puppet_master_ip puppet >> /etc/hosts

git clone https://github.com/jryates120/ror-nginx-puppet.git >> $LOGFILE

sed -i /etc/default/puppet -e 's/START=no/START=yes/'

service puppet restart

puppet apply --verbose --modulepath=./ror-nginx-puppet/modules ror-nginx-puppet/manifests/site.pp || tee -a $LOGFILE
