server:
  port: 8888
  ssl:
    enabled: true
    # If client auth is set to need, then and client which will connect to config server will also provide it's certificate already shared by config server with him
    #client-auth: need
    key-store: file:{{ app_conf_home }}/config-server-tls.jks
    key-store-password: {{ config_server_key_store_password }}
    key-alias: config-server
    key-store-type: pkcs12
    # trust store will be used by config server to trust the client which can access it.
    # In my trust store I have added a trusted certificate of some another application
    trust-store: {{ app_conf_home }}/config-server-trust-store.jks
    trust-store-password: {{ config_server_trust_store_password }}
    trust-store-type: pkcs12
# these settings are required to encrypt or decrypt data written in backend
encrypt:
  keyStore:
    #Path to key store files, Please copy all the files in resources/keystore directoryto some location and give full path here
    location: file:{{ app_conf_home }}/config-server-crypto.jks
    password: {{ config_server_crypto_password }}
    alias: config-server-crypto
    secret: {{ config_server_crypto_secret }}
spring:
  main:
    allow-bean-definition-overriding: true
  application:
    name: config-server
  security:
    basic:
      enabled: true
      path: /**
    user:
      name: admin
      # plain password is : admin (Created via config-server-crypto.jks)
      password: '{cipher}AQAzxH9TduAAv9V365PJFAuzThf7H0idjbBPRnTrxg3DxN7MYVByMwq+GQ+X5vcrQ9hHJgetj9qI42LAJBr/1/hPC4c2k2ghO1TT2v6a5iECvwREZc6OveXiphOoi0fSvFJ9mU70QJLV7O3uFCG/8s1Qq/jPH9kZCkWv3EEIZVdQepX4NwL1oxBSLydO5bhxCx12fl3SdtHXLTl1xnx5nk8vazA/pXumdi4cj4yt2Ekwt9uytpkldWiKjVzOAJ30y+zMbCcwqbrFOOVm32lo0+qwS8eC+EJVVXCt5q975/vUhPcsc56h7t3q6LxOFlm53I8hgtB+DMaXda7fIsJv7anQnhp/U73zbhfZllHyq2xd439jtfQ21SebGhvizREmt3g='
  profiles:
    active: vault
  # settings for spring vault library to create connection with vault
  cloud:
    vault:
      port: 8300
      host: 192.168.2.108
      scheme: https
      authentication: CERT
      backend: secret
      ssl:
        # This keystore contains both private key and certificate required to login into VAULT via CERT
        #Path to vault-cert.pkcs12, Please copy all the files in resources/keystore directoryto some location and give full path here
        key-store: file:{{ app_conf_home }}/vault-cert.pkcs12
        key-store-password: {{ vault_cert_keystore_password }}
        cert-auth-path: cert
      kv-version: 1
    # settings for config server to connect to create connection with vault and authenticating via CERT
    config:
      server:
        vault:
          port: 8300
          host: 192.168.2.108
          scheme: https
          authentication: CERT
          backend: secret
          ssl:
            # This keystore contains both private key and certificate required to login into VAULT via CERT
            key-store: file:{{ app_conf_home }}/vault-cert.pkcs12
            key-store-password: {{ vault_cert_keystore_password }}
            cert-auth-path: cert
          kv-version: 1
