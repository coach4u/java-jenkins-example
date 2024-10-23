FROM tomcat:8-alpine
 
COPY target/demo.war /usr/local/tomcat/webapps/demo.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
