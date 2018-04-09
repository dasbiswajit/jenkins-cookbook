#
# Cookbook:: jenkins
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

user_name = "admin"
profile_name = "security"
region_name = "eu-west-1"

yum_repository 'jenkins' do
  description "Jenkins Repo"
  baseurl "http://pkg.jenkins.io/redhat"
  gpgkey "https://jenkins-ci.org/redhat/jenkins-ci.org.key"
  action :create
end

for package in ['jenkins', 'java-1.8.0-openjdk'] do
  yum_package "#{package}" do
    package_name "#{package}"
    action :install
  end
end

for dir in ['/var/lib/jenkins/.aws', '/var/lib/jenkins/users', '/var/lib/jenkins/users/admin']
  directory "#{dir}" do
    owner 'ec2-user'
    group 'ec2-user'
    mode '0750'
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
  sudo sh jenkins_plugin.sh role-strategy github-branch-source pipeline-github-lib pipeline-stage-view git subversion ssh-slaves matrix-authmatrix-auth cloudbees-folder antisamy-markup-formatter build-timeout credentials-binding timestamper ws-cleanup ant gradle workflow-aggregator pam-auth ldap email-ext mailer >> $logfile
  EOH
end

template "/var/lib/jenkins/.aws/config" do
  source 'aws-config.erb'
  mode '0744'
  variables ({
    :profile => profile_name,
    :region => region_name
  })
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
