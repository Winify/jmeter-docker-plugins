FROM openjdk:8-alpine
LABEL maintainer="vgraics"

ARG JMETER_VERSION=5.0

ENV PROTOCOL=http
ENV DOMAIN=localhost
ENV PORT=8080

# JMeter install
RUN apk update && \
    apk add --no-cache nss && \
    mkdir opt/tests && \
    mkdir opt/results && \
    mkdir tmp/jmeter && \
    wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -P /tmp/jmeter && \
    tar -xvzf /tmp/jmeter/apache-jmeter-${JMETER_VERSION}.tgz -C /opt && \
    rm -rf /tmp/jmeter

ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV PATH=${PATH}:${JMETER_HOME}/bin

# ElasticSearch plugin install
RUN wget http://central.maven.org/maven2/kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar -P ${JMETER_HOME}/lib && \
    wget http://central.maven.org/maven2/kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar -P ${JMETER_HOME}/lib/ext && \
    java -cp ${JMETER_HOME}/lib/ext/jmeter-plugins-manager-1.3.jar org.jmeterplugins.repository.PluginManagerCMDInstaller && \
    ${JMETER_HOME}/bin/PluginsManagerCMD.sh install jmeter.backendlistener.elasticsearch

WORKDIR	${JMETER_HOME}/bin
VOLUME [ "/opt/tests" ]
VOLUME [ "/opt/results" ]

ADD entrypoint.sh ${JMETER_HOME}/bin
ENTRYPOINT [ "./entrypoint.sh" ]