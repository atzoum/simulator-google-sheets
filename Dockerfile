FROM maven:3.5-jdk-8-alpine as builder

COPY src /usr/src/app/src
COPY pom.xml /usr/src/app

RUN mvn -f /usr/src/app/pom.xml clean package

FROM openjdk:8-jdk

ENV DEPLOY_DIR /app
EXPOSE 8443
USER 0
VOLUME /tmp
RUN mkdir ${DEPLOY_DIR}
COPY --from=builder /usr/src/app/target/simulator-google-sheets-0.1-SNAPSHOT.jar $DEPLOY_DIR/app.jar
RUN find $DEPLOY_DIR -name '*.jar' -exec chmod a+x {} +
CMD java -Djava.security.egd=file:/dev/./urandom -jar ${DEPLOY_DIR}/app.jar
USER 1000