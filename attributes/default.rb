# Cookbook: test-cookbook
# Attribute file: default

# default attributes for basic splunk install configuration
node.default['test-cookbook']['attribute1'] = 'value from Attribute'

# Jenkins master attributes
node.default['test-cookbook']['jenkins-master']['port'] = '8081'
node.default['test-cookbook']['jenkins-master']['user-name']= 'admin'

# Jenkins slave related attributes
node.default['test-cookbook']['jenkins-slave']['slave-val'] = 'value'




