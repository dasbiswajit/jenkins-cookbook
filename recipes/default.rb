# Cookbook: test-cookbook
# Recipe: default

# Get the current version from metadata
Log.debug("Node attributes from" + node.default['test-cookbook']['attribute1'])

bash 'jenkins Installation' do
  code <<-EOH
            sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
            sleep 10
            sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
            sleep 10
            sudo yum install jenkins -y
            sleep 30
            sudo service jenkins start


   EOH
end
