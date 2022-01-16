# based on examples from
# https://github.com/Praqma/praqma-jenkins-casc

FROM jenkins/jenkins:lts-jdk11

COPY plugins_list.txt /usr/share/jenkins/ref/plugins_list.txt
ARG JAVA_OPTS
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"

RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins_list.txt
