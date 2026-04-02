#!/bin/bash

echo "[START] SSHD"
/usr/sbin/sshd

echo "[START] Tomcat"
exec /opt/tomcat/bin/catalina.sh run

