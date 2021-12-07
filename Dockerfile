FROM maven:3.8.3-openjdk-11 as builder

ENV no_proxy "172.16.253.106"
ENV https_proxy "http://172.21.31.17:8080"
ENV http_proxy "http://172.21.31.17:8080"

copy ./pom.xml /tmp/pom.xml
copy maven/settings.xml /usr/share/maven/ref/

copy . /usr/src/

workdir /usr/src/
run mvn -B --settings /usr/share/maven/ref/settings.xml package

FROM tomcat:9.0
COPY --from=builder /usr/src/target/*.war /usr/local/tomcat/webapps
CMD ["catalina.sh", "run"]