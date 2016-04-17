# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install updates
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get install -y wget curl supervisor

# Install dependencies
RUN apt-get install -y git-core 
RUN apt-get install -y build-essential

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Add openhab
RUN wget -qO - 'https://bintray.com/user/downloadSubjectPublicKey?username=openhab' | sudo apt-key add -
RUN echo "deb http://dl.bintray.com/openhab/apt-repo stable main" | sudo tee /etc/apt/sources.list.d/openhab.list
RUN apt-get update
RUN apt-get install -y openhab-runtime
VOLUME /etc/openhab

# Setup services
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /var/log/supervisord
EXPOSE 8080

# My own requirements
RUN apt-get install -y \
	openhab-addon-binding-snmp \
	openhab-addon-binding-plex \
	openhab-addon-persistence-mqtt \
	openhab-addon-binding-asterisk \
	openhab-addon-action-mail \
	openhab-addon-action-mqtt \
	openhab-addon-action-prowl \
	openhab-addon-action-weather \
	openhab-addon-binding-dmx-ola \
	openhab-addon-binding-http \
	openhab-addon-binding-ntp \
	openhab-addon-binding-systeminfo \
	openhab-addon-binding-tcp \
	openhab-addon-binding-wol
	

CMD supervisord -c /etc/supervisor/supervisord.conf
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
