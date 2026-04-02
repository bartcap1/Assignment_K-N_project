FROM rockylinux/rockylinux:9

RUN dnf install -y java-21-openjdk wget tar && dnf clean all

ARG TOMCAT_VERSION=10.1.28

WORKDIR /opt

RUN wget https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
	&& tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz \
	&& mv apache-tomcat-${TOMCAT_VERSION} /opt/tomcat \
	&& rm -f apache-tomcat-${TOMCAT_VERSION}.tar.gz

RUN chmod +x /opt/tomcat/bin/*.sh  

EXPOSE 8080

  

ENTRYPOINT ["/opt/tomcat/bin/catalina.sh", "run"]

