FROM rockylinux/rockylinux:9

ARG NEXUS_VERSION=3.70.1-02

RUN dnf install -y java-17-openjdk wget tar && dnf clean all

RUN useradd -r -m nexus

WORKDIR /opt

RUN wget https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz 

RUN wget https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz \ 
	&& tar -xvf nexus-${NEXUS_VERSION}-unix.tar.gz \
	&& mv nexus-${NEXUS_VERSION} nexus \
	&& rm -f nexus-${NEXUS_VERSION}-unix.tar.gz \
	&& chown -R nexus:nexus /opt/nexus

USER nexus

EXPOSE 8081

ENTRYPOINT ["/opt/nexus/bin/nexus", "run"]

