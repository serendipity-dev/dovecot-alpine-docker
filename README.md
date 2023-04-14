# dovecot-alpine-docker
Public Docker image running an Dovecot server on Alpine Linux set up to use an OpenLDAP


ENV LDAP_HOST_ADDR "127.0.0.1"

ENV LDAP_HOST_PORT "389"

ENV DOVECOT_USER_OU "people"

ENV DOVECOT_USER_UID "dovecot"

ENV DOVECOT_USER_PWD "password"

ENV MAIL_USERS_OU "people"

ENV SUFFIX "dc=example,dc=com"

ENV PEM_CERT_FILENAME "server.pem"

ENV KEY_CERT_FILENAME "server.key"
