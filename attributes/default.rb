# Cookbook: jenkins-cookbook

node.default['jenkins-cookbook']['jenkins-master']['profile'] = 'security'
node.default['jenkins-cookbook']['jenkins-master']['region'] = 'eu-west-1'
node.default['jenkins-cookbook']['jenkins-master']['efs_id'] = 'efsid'
node.default['jenkins-cookbook']['jenkins-master']['efs_suffix'] = 'efs.eu-west-1.amazonaws.com'
