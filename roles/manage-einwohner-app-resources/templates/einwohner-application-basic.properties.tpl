env = dev
spring.application.name = einwohner

# Config server properties
config.server.url = https://192.168.2.104:8888
config.server.user = admin
#######################Sensitive data#######################
config.server.password = {{ config_server_password }}

server.ssl.key-store = /usr/local/tomcat/app-conf/einwohner-tls.jks
#server.ssl.key-store = /home/raman/app-config/einwohner-tls.jks
#######################Sensitive data#######################
server.ssl.key-store-password = {{ einwohner_tls_key_store_password }}
server.ssl.key-alias = einwohner
server.ssl.key-store-type = pkcs12

server.ssl.trust-store = /usr/local/tomcat/app-conf/einwohner-trust-store.jks
#server.ssl.trust-store = /home/raman/app-config/einwohner-trust-store.jks
#######################Sensitive data#######################
server.ssl.trust-store-password= {{ einwohner_trust_store_password }}
server.ssl.trust-store-type=pkcs12

# Spring Hibernate properties
spring.jpa.hibernate.ddl-auto=none
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
