# dovecot-alpine-docker
Public Docker image running an Dovecot server on Alpine Linux set up to use an OpenLDAP

Default env variables values:


* LDAP_HOST_ADDR "127.0.0.1"
* LDAP_HOST_PORT "389"
* DOVECOT_USER_OU "people"
* DOVECOT_USER_UID "dovecot"
* DOVECOT_USER_PWD "password"
* MAIL_USERS_OU "people"
* SUFFIX "dc=example,dc=com"
* PEM_CERT_FILENAME "server.pem"
* KEY_CERT_FILENAME "server.key"
