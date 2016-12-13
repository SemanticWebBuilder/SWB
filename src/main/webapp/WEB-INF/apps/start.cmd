#!/bin/sh
cd $(cd ${0%/*} && echo $PWD)

JAVA_OPTS="-Xss256k -Xms64m -Xmx512m -XX:MaxPermSize=128m -Dfile.encoding=ISO8859-1"
export JAVA_OPTS

_RUNJAVA=java

exec "$_RUNJAVA" $JAVA_OPTS -Xverify:none \
-Djava.endorsed.dirs=jetty/lib/endorsed -Dwebapp=../../ \
-Dorg.xml.sax.parser=org.apache.xerces.parsers.SAXParser \
-Djetty.port=8080 -Djetty.admin.port=8089 \
-Dloader.jar.repositories=jetty/lib,jetty/lib/endorsed \
-Dloader.main.class=org.mortbay.jetty.Server \
Loader jetty/conf/main.xml jetty/conf/admin.xml

