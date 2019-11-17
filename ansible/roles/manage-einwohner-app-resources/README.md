Files
=====
1. einwohner-tls.jks : Einwohner server's key-store containing it's public key and private key for TLS communication.
2. einwohner-public-key.crt : Certificate / Public key for all other applications to connect config server via https
3. einwohner-trust-store.jks : Trust store to be used by einwohner app to trust other applications e.g. config-server. Their certificates will be present in this store.
4. einwohner-application.properties : einwohner app server's properties.

Einwohner- How to create keystores / public certificates
-------------------------------------------------------------
1. Create keypairs for einwohner
 keytool -genkeypair -alias einwohner -keyalg RSA -keysize 2048 -storetype pkcs12 -keystore einwohner-tls.jks
 Password: einwohner
 
2. Create public certificate for other applications to add in their trust store
 keytool -export -alias einwohner -file einwohner-public-key.crt -keystore einwohner-tls.jks
 Password: einwohner

3. cp einwohner-tls.jks einwohner-trust-store.jks (So we have a trust store containing public and private keys of einwohner already)

4. Now import config-server certificate into einwohner trust store
 keytool -import -alias config-server -file {path to file}/config-server-public-key.crt -storetype pkcs12 -keystore einwohner-trust-store.jks
 Password: einwohner

How to store secrets
====================
./vault-write-secret.sh einwohner-dev-1.0-SNAPSHOT-config.json