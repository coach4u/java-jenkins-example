FROM tomcat:8-alpine
 
COPY target/*.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD [“catalina.sh”, “run”]
