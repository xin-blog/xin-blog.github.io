---
title: Setup Private Confluence Server on EC2 Amazon Linux
---

## Login with ec2-user using pem.key
```bash
sudo vi /etc/environment
```

Add following lines:

```
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
```

```bash
chmod 600 pem.key
ssh -i pem.key ec2-user@ec2_ip
```

Add ops account

```bash
yum update

sudo adduser ops
sudo usermod -a -G wheel ops
sudo echo "ops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/cloud-init

sudo su ops
cd
mkdir .ssh
echo "your_pub_key" >> .ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
exit
```

then login as ops account
```bash
ssh -l ops ec2_ip
```


## Install Confluenct with binary package
```bash
./atlassian-confluence-6.6.0-x64.bin
```

Configure the Confluence Tomcat connector:

## Change confluence configuration to allow run behind NGINX with SSL
[Running Confluence behind NGINX with SSL](https://confluence.atlassian.com/confeap/running-confluence-behind-nginx-with-ssl-849150880.html)

Next, in the same <installation-directory>/conf/server.xml file, locate this code segment:
```
<Connector port="8090" connectionTimeout="20000" redirectPort="8443"
                maxThreads="48" minSpareThreads="10"
                enableLookups="false" acceptCount="10" debug="0" URIEncoding="UTF-8"
                protocol="org.apache.coyote.http11.Http11NioProtocol"/>
```

And add the last line as follows:

```
<Connector port="8090" connectionTimeout="20000" redirectPort="8443"
                maxThreads="48" minSpareThreads="10"
                enableLookups="false" acceptCount="10" debug="0" URIEncoding="UTF-8"
                protocol="org.apache.coyote.http11.Http11NioProtocol" 
                proxyName="www.yourdomain.com" proxyPort="443" scheme="https"/>
```

## Install nginx & postgresql server

```bash
sudo yum install nginx
```

## Nginx reverse proxy to confluence
```bash
sudo openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout /etc/ssl/certs/yourdomain.key -out /etc/ssl/certs/yourdomain.pem
```

```
server{
        listen          80;
        server_name     yourdomain;
        rewrite ^(.*)$  https://yourdomain$1 permanent;
}

server {
        listen          443 default_server ssl;
        server_name     yourdomain;

        access_log  /var/log/nginx/yourdomain-access;
        error_log   /var/log/nginx/yourdomain-error;

        ssl_certificate /etc/ssl/certs/yourdomain.pem;
        ssl_certificate_key /etc/ssl/certs/yourdomain.key;

        ssl_session_timeout  5m;
 
        ssl_protocols  SSLv2 SSLv3 TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers   on;

        location /confluence {
                client_max_body_size 100m;
                proxy_set_header X-Forwarded-Host $host;
                proxy_set_header X-Forwarded-Server $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_pass http://localhost:8090/confluence;
        }
        location /synchrony {
                proxy_set_header X-Forwarded-Host $host;
                proxy_set_header X-Forwarded-Server $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_pass http://localhost:8091/synchrony;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
        }
}
```

## Setup confluence db in postgresql server

```bash
sudo yum install postgresql96-server

sudo su postgres
psql
\l
CREATE ROLE confluenceuser LOGIN ENCRYPTED PASSWORD 'secret' NOINHERIT VALID UNTIL 'infinity';
CREATE DATABASE confluencedb WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0 OWNER=confluenceuser;
GRANT ALL PRIVILEGES ON DATABASE confluencedb TO confluenceuser;
\l

```

## Setup confluence email notification

JNDI Email Sending

[Setting Up a Mail Session for the Confluence Distribution
](https://confluence.atlassian.com/doc/setting-up-a-mail-session-for-the-confluence-distribution-6328.html)

## Finish

Open http://yourdomain/ to finish confluence setup in web browser
