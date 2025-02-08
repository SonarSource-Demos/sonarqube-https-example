from redhat/ubi9:latest

# If your build of the docker image fails, your firewall may be intercepting SSL traffic,
# and you may need to install the firewall's certificate into the container.
# Uncomment the below lines and replace my-firewall-cert.cer with the name of your firewall's certificate.
# COPY my-firewall-cert.cer /etc/pki/ca-trust/source/anchors/
# RUN update-ca-trust

# Install the required packages and Java 17
RUN yum update -y && \
    yum install -y java-17-openjdk-devel && \
    yum install -y ca-certificates && \
    yum install -y unzip && \
    yum install -y git && \
    yum install -y openssl && \
    yum clean all

# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk

# Set the working directory
WORKDIR /opt

# Copy the server certificate into the container
COPY server.crt /opt/

# Install SSLPoke
COPY SSLPoke.class /opt/
# If you want to use the latest version of SSLPoke, you can download it from the Atlassian website.
# RUN curl -o /opt/SSLPoke.class https://confluence.atlassian.com/kb/files/779355358/779355357/1/1433955517810/SSLPoke.class

# Do nothing
CMD ["tail", "-f", "/dev/null"]