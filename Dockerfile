FROM scratch
EXPOSE 9090
COPY target/*.war /usr/local/
ENTRYPOINT ["java","-jar","/devops.war"]
