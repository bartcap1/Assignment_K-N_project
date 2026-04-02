FROM rockylinux/rockylinux:9

RUN dnf install -y openssh-server openssh-clients java-21-openjdk wget tar && dnf clean all

ARG TOMCAT_VERSION=10.1.28

WORKDIR /opt

RUN wget https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
	&& tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz \
	&& mv apache-tomcat-${TOMCAT_VERSION} /opt/tomcat \
	&& rm -f apache-tomcat-${TOMCAT_VERSION}.tar.gz \
	&& chmod +x /opt/tomcat/bin/*.sh  

RUN useradd devops \
	&& echo "devops:devops" | chpasswd \
	&& mkdir -p /home/devops/.ssh \
	&& chown -R devops:devops /home/devops/.ssh

RUN ssh-keygen -A
RUN mkdir -p /run/sshd


EXPOSE 8080 22

  
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

