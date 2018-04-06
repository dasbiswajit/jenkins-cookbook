#
# Cookbook:: jenkins
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

user_name = "admin"

yum_repository 'jenkins' do
  description "Jenkins Repo"
  baseurl "http://pkg.jenkins.io/redhat"
  gpgkey "https://jenkins-ci.org/redhat/jenkins-ci.org.key"
  action :create
end

yum_package 'jenkins' do
action :install
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
  sudo sh jenkins_plugin.sh role-strategy github-branch-source pipeline-github-lib pipeline-stage-view git subversion ssh-slaves matrix-authmatrix-auth cloudbees-folder antisamy-markup-formatter build-timeout credentials-binding timestamper ws-cleanup ant gradle workflow-aggregator pam-auth ldap email-ext mailer >> $logfile
  EOH
end


template "/var/lib/jenkins/users/admin/config.xml" do
  source 'admin-config.xml.erb'
  mode '0644'
  owner 'jenkins'
  group 'jenkins'
  variables ({
    :user => user_name
})
  notifies :restart, "service[jenkins]"
end

template "/var/lib/jenkins/config.xml" do
  source 'jenkins-config.xml.erb'
  mode '0644'
  owner 'jenkins'
  group 'jenkins'
  variables ({
    :user => user_name
})
  notifies :restart, "service[jenkins]"
end

service 'jenkins' do
  supports :restart => :true
  action [ :enable, :start ]
end
