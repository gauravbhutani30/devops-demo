FROM openjdk:8-jdk-alpine
EXPOSE 9090
COPY target/*.war /usr/local/
ENTRYPOINT ["java","-jar","/devops.war"]
