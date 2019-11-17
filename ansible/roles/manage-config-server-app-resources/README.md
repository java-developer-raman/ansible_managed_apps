Files
=====
1. config-server-tls.jks : Config server's key-store containing it's public key and private key for TLS communication.
2. config-server-public-key.crt : Certificate / Public key for all other applications to connect config server via https
3. config-server-trust-store.jks : Trust store to be used by config-server to trust other applications e.g. einwohner. Their certificates will be present in this store.
4. config-server-crypto.jks : Config server's key store containing RSA pair to encrypt and decrypt plain data while saving and loading to and from backend.
5. config-server-git-application.yml : Application properties to connect GIT as backend.
6. config-server-vault-application.yml : Application properties to connect Vault as backend

# Config Server

Config Server created through spring cloud config to manage configurations in a centralized manner.

How to make Config server secure
================================
1. Download Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files 8.
2. Replace the 2 policy files in the JRE lib/security directory with the ones that you downloaded.
3. Create an RSA key pair

Config Server - How to create keystores / public certificates
-------------------------------------------------------------
1. Create keypairs for config-server
 keytool -genkeypair -alias config-server -keyalg RSA -keysize 2048 -storetype pkcs12 -keystore config-server-tls.jks
 Password: config-server
 
2. Create public certificate for other applications to add in their trust store
 keytool -export -alias config-server -file config-server-public-key.crt -keystore config-server-tls.jks

3. cp config-server-tls.jks config-server-trust-store.jks (Copy tls file into trust-store file)

4. Import einwohner certificate into config-server trust store
 keytool -import -alias einwohner -file {path-to-file}/einwohner-public-key.crt -storetype pkcs12 -keystore config-server-trust-store.jks

5. Import vault certificate in trust store 
  keytool -import -alias vault -file {path-to-file}/vault-tls-certificate.crt -storetype pkcs12 -keystore config-server-trust-store.jks

6. Create RSA pair for encryption and decryption
  keytool -genkeypair -alias config-server-crypto -keyalg RSA -keysize 2048 -storetype pkcs12 -keystore config-server-crypto.jks
  Password: config-server-crypto
