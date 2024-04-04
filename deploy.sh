aws s3 cp s3://appweb01/sample/target/demo.war /tmp
mv /tmp/demo.war /opt/tomcat/webapps/demo.war
/opt/tomcat/bin/shutdown.sh
/opt/tomcat/bin/startup.sh


