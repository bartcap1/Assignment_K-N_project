FROM rockylinux/rockylinux:9

ARG NEXUS_VERSION=3.90.2-06

RUN dnf install -y java-17-openjdk wget tar && dnf clean all

RUN useradd -r -m nexus

WORKDIR /opt 

RUN wget https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-linux-x86_64.tar.gz \ 
	&& tar -xvf nexus-${NEXUS_VERSION}-linux-x86_64.tar.gz \
	&& mv nexus-${NEXUS_VERSION} nexus \
	&& rm -f nexus-${NEXUS_VERSION}-linux-x86_64.tar.gz


RUN mkdir -p /opt/sonatype-work/nexus3 \
	&& chown -R nexus:nexus /opt/sonatype-work \
	&& chown -R nexus:nexus /opt/nexus


USER nexus

EXPOSE 8081

ENTRYPOINT ["/opt/nexus/bin/nexus", "run"]

