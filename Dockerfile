FROM openjdk:8-jdk-alpine
EXPOSE 8080
COPY target/*.war /usr/local/
ENTRYPOINT ["java","-jar","/usr/local/demo-0.0.4.war"]
