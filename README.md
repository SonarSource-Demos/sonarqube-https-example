# sonarqube-https-example
==========================

The goal of this project is to demonstrate how to enforce HTTPS for SonarQube and provide an environment to test the validity of your own TLS certificates.

In this project, you will:
1. Generate self-signed TLS certificates
2. Install the certificates in a proxy in front of SonarQube
3. Test the HTTPS connection to SonarQube using SSLPoke

**Prerequisites**

* [Docker](https://docs.docker.com/install/) (install)
* [Docker Compose](https://docs.docker.com/compose/install/) (install)

**Step 1: Generate Self-Signed Certificate and Key**
--------------------------------------------------

For ease of use, I have provided scripts.

Generate the self-signed certificate and private key by running the below script from the `certificates` folder:
```sh
./create-keys.sh
```
This will generate two files:
```plaintext
server.crt (public certificate)
server.key (private key)
```
⚠️ For production, please generate your own certificates as these are potentially insecure. The passphrase `changeit` is used to generate the certificate and key. For production, you should use your own secret passphrase and your own configuration file, instead of the provided `openssl.cnf`.⚠️ 

**Step 2: Install Self-Signed Certificate into Proxy**
---------------------------------------------------

Install the self-signed TLS certificate into the proxy to enforce HTTPS with the newly generated certificates.

In this example, we will use [nginx](https://nginx.org/) as the proxy to front SonarQube server and enforce HTTPS. Note that the `nginx.conf` file is already configured to point to the correct keys (`server.crt` and `server.key`) for you.

To copy these keys to all necessary containers, run the below script from the `certificates` folder:
```sh
./copy.sh
```

**Step 3: Build and Run Containers**
------------------------------------

To build the Docker containers, run the following command:
```sh
docker-compose build
```
If you have a firewall that intercepts TLS traffic, you may need to modify the Dockerfiles to include your firewall certificate during the build process. Examples of this are commented out in the Dockerfiles.

To start the containers, run:
```sh
docker-compose up -d
```

**Step 4: Test HTTP Connection**
-----------------------------------

To test HTTP connections, please run the below commands from the `ssl-poke` container. You can accomplish this by SSH'ing into the container or using Docker Desktop to run it in a GUI environment.

With this setup, you can bypass the proxy by requesting the SonarQube server directly via port 9000.

Test if you can connect to SonarQube via HTTP
```sh
curl http://sonarqube:9000
```

It is expected to receive a HTML response from the SonarQube server.
```html
<!DOCTYPE html>
<head>
<meta charset="UTF-8" />
....etc.....
```

**Step 5: Test HTTPS Connection**
-----------------------------------

To test HTTPS connections, please run the below commands from the `ssl-poke` container. You can accomplish this by SSH'ing into the container or using Docker Desktop to run it in a GUI environment.

With this setup, you can connect to the SonarQube via HTTPS through the proxy server via port 443. Run the below command to use SSLPoke to test this HTTPS connection.
```sh
java -Djavax.net.ssl.trustStore=$JAVA_HOME/lib/security/cacerts \
     -Djavax.net.ssl.trustStorePassword=changeit \
     SSLPoke proxy 443
```
An HTTPS error like the below is expected:
```log
sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
    at java.base/sun.security.validator.PKIXValidator.doBuild(PKIXValidator.java:439)
         ... 19 more
```

To resolve the HTTPS error, you will need to ensure that the JVM has the TLS certificates installed in the Java trust store. To do this:

1. Copy the certificate into Java's CA trust store:
```sh
cp /opt/server.crt $JAVA_HOME/lib/security/
```
2. Use `keytool` to install the certificate in the default Java truststore:
```sh
keytool -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias mycert -file $JAVA_HOME/lib/security/server.crt
```
⚠️ In production, replace `changeit` with your own passphrase and replace `mycert` with your own alias for the certificate. ⚠️


Finally, test SSL Poke:
```sh
java -Djavax.net.ssl.trustStore=$JAVA_HOME/lib/security/cacerts \
     -Djavax.net.ssl.trustStorePassword=changeit \
     SSLPoke proxy 443
```

Successful message is expected
```sh
Successfully connected
```

By following these steps, you should be able to successfully set up HTTPS for SonarQube and test the validity of your self-signed TLS certificates.