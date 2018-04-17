#
# Cookbook:: jenkins
# Recipe:: master
#
# Copyright:: 2018, The Authors, All Rights Reserved.

#Log.debug("Jenkins port number." + node.default['jenkins-cookbook']['jenkins-master']['port'])

yum_repository 'jenkins' do
  description "Jenkins Repo"
  baseurl "http://pkg.jenkins.io/redhat"
  gpgkey "https://jenkins-ci.org/redhat/jenkins-ci.org.key"
  action :create
end

user 'jenkins' do
  manage_home true
  comment 'Jenkins'
  home '/var/lib/jenkins'
  shell '/bin/bash'
end

for package in ['jenkins', 'mysql'] do
  yum_package "#{package}" do
    package_name "#{package}"
    action :install
  end
end

for dir in ['/var/lib/jenkins/.aws', '/var/lib/jenkins/users', '/var/lib/jenkins/users/admin', '/var/lib/jenkins/.ssh']
  directory "#{dir}" do
    action :create
  end
end

git '/tmp/jenkins-script' do
  repository "https://github.com/dasbiswajit/jenkins-script.git"
  reference "master"
  action :checkout
end

bash 'jenkins_plugin' do
  code <<-EOH
  logfile=/home/ec2-user/logfile.txt
  cd /tmp/jenkins-script
  sudo sh jenkins_plugin.sh role-strategy github-branch-source pipeline-github-lib pipeline-stage-view git subversion ssh-slaves matrix-authmatrix-auth cloudbees-folder antisamy-markup-formatter build-timeout credentials-binding timestamper ws-cleanup ant gradle workflow-aggregator pam-auth ldap email-ext mailer blueocean | tee -a $logfile
  sed -i -e 's+JENKINS_PORT=\"8080\"+JENKINS_PORT="8081"+' /etc/sysconfig/jenkins
  echo "Info:: Successfully Updated Jenkins Port" | tee -a $logfile
  echo 'export {http,https}_proxy="vpce-0c72110145328a789-ygatkcz5.vpce-svc-0a79140bd223a5a11.eu-west-1.vpce.amazonaws.com:3128"' | sudo tee -a /etc/bashrc
  EOH
end


template "/var/lib/jenkins/users/admin/config.xml" do
  source 'admin-config.xml.erb'
  mode '0644'
  owner 'jenkins'
  group 'jenkins'
end

template "/var/lib/jenkins/config.xml" do
  source 'jenkins-config.xml.erb'
  mode '0644'
  owner 'jenkins'
  group 'jenkins'
end

service 'jenkins' do
  supports :restart => :true, :reload => true
  action [ :enable, :start ]
end
