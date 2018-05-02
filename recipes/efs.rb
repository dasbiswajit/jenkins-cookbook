#
# Cookbook:: jenkins
# Recipe:: nfs/efs
#
# Copyright:: 2018, The Authors, All Rights Reserved.

suffix = node.default['jenkins-cookbook']['jenkins-master']['efs_id']
efsid = node.default['jenkins-cookbook']['jenkins-master']['efs_suffix']
efs_uri = "#{suffix}.#{efsid}:/"

mount '/var/lib/jenkins' do
  device efs_uri
  fstype 'nfs4'
  options 'nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2'
  action [:mount, :enable]
end
