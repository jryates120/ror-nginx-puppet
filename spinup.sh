#!/bin/bash
ec2-run-instances -g sg-d32d54b4 -s subnet-0a34df7c -k puppet-hosts -f install.sh -t t2.micro --region us-west-2 ami-9abea4fb
