#!/bin/sh
# docker entrypoint script
# configures and starts Dovecot

# replace variables in dovecot-ldap.conf.ext
DOVECOT_LDAP_CONF="/etc/dovecot/dovecot-ldap.conf.ext"

sed -i "s~%ROOT_USER%~$ROOT_USER~g" "$DOVECOT_LDAP_CONF"
sed -i "s~%SUFFIX%~$SUFFIX~g" "$DOVECOT_LDAP_CONFF"
sed -i "s~%ACCESS_CONTROL%~$ACCESS_CONTROL~g" "$DOVECOT_LDAP_CONF"
sed -i "s~%LDAP_HOST_ADDR%~$LDAP_HOST_ADDR~g" "$DOVECOT_LDAP_CONF"
sed -i "s~%LDAP_HOST_PORT%~$LDAP_HOST_PORT~g" "$DOVECOT_LDAP_CONF"
sed -i "s~%DOVECOT_USER_OU%~$DOVECOT_USER_OU~g" "$DOVECOT_LDAP_CONF"
sed -i "s~%DOVECOT_USER_UID%~$DOVECOT_USER_UID~g" "$DOVECOT_LDAP_CONF"
sed -i "s~%DOVECOT_USER_PWD%~$DOVECOT_USER_PWD~g" "$DOVECOT_LDAP_CONF"
sed -i "s~%MAIL_USERS_OU%~$MAIL_USERS_OU~g" "$DOVECOT_LDAP_CONF"
sed -i "s~%SUFFIX%~$SUFFIX~g" "$DOVECOT_LDAP_CONF"

# replace variables in 10-ssl.conf
DOVECOT_SSL_CONF="/etc/dovecot/conf.d/10-ssl.conf"

sed -i "s~%PEM_CERT_FILENAME%~$PEM_CERT_FILENAME~g" "$DOVECOT_SSL_CONF"
sed -i "s~%KEY_CERT_FILENAME%~$KEY_CERT_FILENAME~g" "$DOVECOT_SSL_CONF"

# Parse dovecot version string from the APK database
DOVECOT_VERSION_STRING="$(
	awk -- '
		BEGIN {
			PKGID  = ""
			PKGNAM = ""
			PKGVER = ""
			
			FS = ":"
		}
		
		{
			if($1 == "C") {
				PKGID  = $2
			} else if($1 == "P") {
				PKGNAM = $2
			} else if($1 == "V") {
				PKGVER = $2
			}
			
			if(PKGID && PKGNAM && PKGVER) {
				if(PKGNAM == "dovecot") {
					print PKGNAM "-" PKGVER "." PKGID
				}
				
				PKGID  = ""
				PKGNAM = ""
				PKGVER = ""
			}
		}
	' /lib/apk/db/installed)"

# Re-run dovecot post-install script (to generate the TLS certificates if they're missing)
tar -xf "/lib/apk/db/scripts.tar" "${DOVECOT_VERSION_STRING}.post-install" -O | sh

# Start Dovecot as usual
echo "Starting Dovecot"
dovecot -F

# run command passed to docker run
exec "$@"
