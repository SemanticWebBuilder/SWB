#!/bin/sh

JAVA_OPTS="-Xss256k -Xms64m -Xmx512m -XX:MaxPermSize=128m -Dfile.encoding=ISO8859-1"
export JAVA_OPTS

# The two previous lines should be ajusted as needed


echo "Using JAVA_HOME:       $JAVA_HOME"
if [ -z "$JAVA_HOME" ]; then
  echo "The JAVA_HOME environment variable is not defined"
  echo "This environment variable is needed to run this program"
  exit 1
fi

_RUNJAVA="$JAVA_HOME"/bin/java

exec "$_RUNJAVA" $JAVA_OPTS -Xverify:none \
-Djava.endorsed.dirs=jetty/lib/endorsed -Dwebapp=../../ \
-Dorg.xml.sax.parser=org.apache.xerces.parsers.SAXParser \
-Djetty.port=8888 -Djetty.admin.port=8889 \
-Dloader.jar.repositories=jetty/lib,jetty/lib/endorsed \
-Dloader.main.class=org.mortbay.jetty.Server \
Loader jetty/conf/main.xml jetty/conf/admin.xml

