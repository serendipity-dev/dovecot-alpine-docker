#!/bin/sh
# docker entrypoint script
# configures and starts Dovecot

# replace variables in dovecot-ldap.conf.ext
DOVECOT_LDAP_CONF="/etc/dovecot/dovecot-ldap.conf.ext"

sed -i "s~%ROOT_USER%~$ROOT_USER~g" "$DOVECOT_LDAP_CONF"
sed -i "s~%SUFFIX%~$SUFFIX~g" "$DOVECOT_LDAP_CONFF"
sed -i "s~%ACCESS_CONTROL%~$ACCESS_CONTROL~g" "$DOVECOT_LDAP_CONF"

# encrypt root password before replacing
#ROOT_PW=$(slappasswd -s "$ROOT_PW")
sed -i "s~%ROOT_PW%~$ROOT_PW~g" "$SLAPD_CONF"

# replace variables in organisation configuration
ORG_CONF="/etc/openldap/organisation.ldif"
sed -i "s~%SUFFIX%~$SUFFIX~g" "$ORG_CONF"
sed -i "s~%ORGANISATION_NAME%~$ORGANISATION_NAME~g" "$ORG_CONF"

# replace variables in user configuration
USER_CONF="/etc/openldap/users.ldif"
sed -i "s~%SUFFIX%~$SUFFIX~g" "$USER_CONF"
sed -i "s~%USER_UID%~$USER_UID~g" "$USER_CONF"
sed -i "s~%USER_GIVEN_NAME%~$USER_GIVEN_NAME~g" "$USER_CONF"
sed -i "s~%USER_SURNAME%~$USER_SURNAME~g" "$USER_CONF"
if [ -z "$USER_PW" ]; then USER_PW="password"; fi
sed -i "s~%USER_PW%~$USER_PW~g" "$USER_CONF"
sed -i "s~%USER_EMAIL%~$USER_EMAIL~g" "$USER_CONF"

# add organisation and users to ldap (order is important)
slapadd -l "$ORG_CONF"
slapadd -l "$USER_CONF"

# add any scripts in ldif
for l in /ldif/*; do
  case "$l" in
    *.ldif)  echo "ENTRYPOINT: adding $l";
            slapadd -l $l
            ;;
    *)      echo "ENTRYPOINT: ignoring $l" ;;
  esac
done

if [ "$LDAPS" = true ]; then
  echo "Starting LDAPS"
  slapd -d "$LOG_LEVEL" -h "ldaps:///"
else
  echo "Starting LDAP"
  slapd -d "$LOG_LEVEL" -h "ldap:///"
fi

# run command passed to docker run
exec "$@"
