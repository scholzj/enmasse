FROM jboss/keycloak:3.3.0.Final

ARG version=latest
ENV VERSION ${version}

ADD ./sasl-plugin/target/sasl-plugin.jar /opt/jboss/keycloak/providers/
ADD ./src/main/xsl/*.xsl /opt/jboss/keycloak/
ADD ./src/main/sh/init-keycloak.sh /opt/jboss/keycloak/bin/

USER root
RUN /opt/jboss/keycloak/bin/init-keycloak.sh
USER jboss
ENV JAVA_OPTS "-Dvertx.cacheDirBase=/tmp -Djboss.bind.address=0.0.0.0 -Djava.net.preferIPv4Stack=true"
