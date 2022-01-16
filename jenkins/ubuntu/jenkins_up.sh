#!/bin/bash
docker pull jenkins/jenkins:lts-jdk11 
docker build /vagrant/jenkins/ -t myci:0.1
# login and run this command under vagrant user
sudo -u vagrant docker run --rm -d -p 8080:8080 --env adminpw=123456 --env CASC_JENKINS_CONFIG=/var/jenkins_conf -v /vagrant/casc_configs:/var/jenkins_conf --env JAVA_OPTS="-Djenkins.install.runSetupWizard=false "  -v jenkins_home:/var/jenkins_home myci:0.1

# Note to update plugins list you can use command
# docker run -it ${JENKINS_IMAGE} bash -c "stty -onlcr && jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt --available-updates --output txt" >  plugins2.txt
