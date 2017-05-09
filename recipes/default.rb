# Cookbook: test-cookbook
# Recipe: default

# Get the current version from metadata
Log.debug("Node attributes from" + node.default['test-cookbook']['attribute1'])

# test file resource
file '/tmp/test.log' do
  content 'This is a test file'
  mode '0755'
  owner 'root'
  group 'root' 
end
# test file resource
file '/tmp/test1.log' do
  content 'This is a test file'
  mode '0755'
  owner 'root'
  group 'root' 
end

