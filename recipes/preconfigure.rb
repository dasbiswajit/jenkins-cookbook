#
# Cookbook:: jenkins
# Recipe:: preinstall
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#bash 'yum update' do
#  code <<-EOH
#  logfile=/home/ec2-user/logfile.txt
#  touch $logfile
#  yum update -y >> $logfile
#  EOH
#end

for package in ['python-setuptools', 'wget', 'unzip', 'java-1.8.0-openjdk', 'nfs-utils.x86_64'] do
  yum_package "#{package}" do
    package_name "#{package}"
    action :install
  end
end

for dir_path in ['/opt/aws/bin', '/var/lib/jenkins'] do
  directory "#{dir_path}" do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
  end
end

bash 'bootstrap_pip_awscli' do
  code <<-EOH
  wget https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz -P /opt/aws/bin  >> $logfile
  easy_install --script-dir /opt/aws/bin aws-cfn-bootstrap-latest.tar.gz >> $logfile
  easy_install pip | tee -a $logfile
  pip install awscli | tee -a $logfile
  EOH
end

include_recipe "jenkins-cookbook::efs"
