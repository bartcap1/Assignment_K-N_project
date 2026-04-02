FROM rockylinux/rockylinux:9

RUN dnf install -y java-21-openjdk git wget unzip maven docker && dnf clean all

RUN useradd -m -d /var/jenkins_home jenkins

ENV JENKINS_HOME=/var/jenkins_home

COPY ./certs/* /etc/pki/ca-trust/source/anchors/

RUN update-ca-trust

RUN alternatives --set java $(readlink -f /usr/lib/jvm/java-21-openjdk*/bin/java)

RUN mkdir -p /opt/jenkins

COPY jenkins.war /opt/jenkins/jenkins.war

EXPOSE 8080 50000

USER jenkins

ENTRYPOINT ["java", "-jar", "/opt/jenkins/jenkins.war"]
