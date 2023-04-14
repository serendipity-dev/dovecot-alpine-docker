# dovecot-alpine-docker
Public Docker image running an Dovecot server on Alpine Linux set up to use an OpenLDAP


ENV LDAP_HOST_ADDR ""

ENV LDAP_HOST_PORT ""

ENV DOVECOT_USER_OU ""

ENV DOVECOT_USER_UID ""

ENV DOVECOT_USER_PWD ""

ENV MAIL_USERS_OU ""

ENV SUFFIX "dc=example,dc=com"

ENV PEM_CERT_FILENAME "server.pem"

ENV KEY_CERT_FILENAME "server.key"
