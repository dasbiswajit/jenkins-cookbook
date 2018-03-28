# Cookbook: test-cookbook
# Recipe: default
user_name = "admin"
# Get the current version from metadata
Log.debug("Node attributes from" + node.default['test-cookbook']['attribute1'])

bash 'jenkins Installation' do
  cwd ::File.dirname('/var/lib/jenkins')
  code <<-EOH
    logfile=/home/ec2-user/logfile.txt
    echo "Info:: Downloading Jenkins repo" >> $logfile
    sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo >> $logfile
    sleep 10
    echo "Info:: Downloading Jenkins key" >> $logfile
    sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key >> $logfile
    sleep 10
    echo "Info:: Installing Jenkins" >> $logfile
    sudo yum install jenkins -y >> $logfile
    sleep 30
    echo "download jenkins plugins script" >> $logfile        
    cd /tmp/jenkins_scripts >> $logfile     
    git clone https://github.com/dasbiswajit/jenkins-script.git >> $logfile     
    cd jenkins-script/ >> $logfile     
    sudo sh jenkins_plugin.sh role-strategy >> $logfile   
    sleep 30            
    sudo service jenkins restart
    sleep 20
    echo "Info:: Jenkins installed successfully" >> $logfile
   EOH
end

template '/var/lib/jenkins/users/admin' do
  source 'admin-config.xml.erb'
  owner 'jenkins'
  group 'jenkins'
  mode '0644'
end


template '/var/lib/jenkins' do
  source 'jenkins-config.xml.erb'
  owner 'jenkins'
  group 'jenkins'
  mode '0644'
end

service 'jenkins' do
  supports :restart => :true
  action [ :enable, :start ]
end
