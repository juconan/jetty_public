# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables
ENV JETTY_VERSION=9.4.43.v20210629 \
    JETTY_HOME=/opt/jetty

# Install Java and Jetty
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless curl && \
    rm -rf /var/lib/apt/lists/*

# Download and install Jetty
RUN mkdir -p ${JETTY_HOME} && \
    curl -SL "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${JETTY_VERSION}/jetty-distribution-${JETTY_VERSION}.tar.gz" | tar -xzC ${JETTY_HOME} --strip-components=1

# application contents
RUN mkdir -p ${JETTY_HOME}/webapps/ROOT
COPY ./jetty/user/user_main.jsp ${JETTY_HOME}/webapps/ROOT/user_main.jsp
COPY ./user_detail.jsp ${JETTY_HOME}/webapps/ROOT/user_detail.jsp



# configure file
COPY ../configure/jdbc-config.xml  ${JETTY_HOME}/etc/jdbc-config.xml
COPY ../configure/index.jsp /opt/jetty/webapps/ROOT/index.jsp





RUN apt-get update && \
    apt install dpkg
RUN apt-get update && \
    apt install wget
WORKDIR ${JETTY_HOME}
RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j_8.1.0-1ubuntu22.04_all.deb
RUN dpkg -i mysql-connector-j_8.1.0-1ubuntu22.04_all.deb

RUN cp /usr/share/java/mysql-connector-j-8.1.0.jar ${JETTY_HOME}/lib/ext/mysql-connector-j-8.1.0.jar


# Expose the default Jetty port
EXPOSE 8080

# Set the working directory to Jetty's base directory
WORKDIR ${JETTY_HOME}
# Start Jetty
CMD ["java", "-jar", "start.jar"]
