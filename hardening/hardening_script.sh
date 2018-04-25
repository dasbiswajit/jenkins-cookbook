#!/bin/bash -xe
## Below command are for Hardening
## DO NOT EDIT BELOW
cd /home/ec2-user/
yum install git wget unzip -y
#git config --global http.sslVerify "false"
#wget --no-check-certificate https://git.aws.edfenergy.net/EDFEnergy/EDF-TSI-Hardening/archive/master.zip
git clone 'git@34.240.248.104:EDFEnergy/multiaccountjenkins.git' -y
cd /multiaccountjenkins/hardening
#git clone https://git.aws.edfenergy.net/EDFEnergy/EDF-TSI-Hardening.git
mv RHEL_Hardening_RHEL7.x.tar.gz /home/ec2-user
tar -xzvf RHEL_Hardening_RHEL7.x.tar.gz
cd /home/ec2-user/RHEL_Hardening
/bin/sh RHEL_Hardening_script.sh
/bin/sh /multiaccountjenkins/hardening/Macafee.sh -i
