FROM scratch
RUN usermod -aG docker ${USER}
EXPOSE 9090
COPY target/*.war /usr/local/
ENTRYPOINT ["java","-jar","/devops.war"]
