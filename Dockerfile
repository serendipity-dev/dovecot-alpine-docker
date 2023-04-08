FROM alpine:3.17.2

# Install pre-requirements
RUN apk add --no-cache ca-certificates
RUN update-ca-certificates

# Disable Dovecot TLS during installation to prevent key from being pregenerated
RUN mkdir -p /etc/dovecot && echo "ssl = no" > /etc/dovecot/local.conf

# Install needed alpine dovecot packages
RUN apk add --no-cache \
	dovecot \
	dovecot-gssapi \
	dovecot-ldap \
	dovecot-lmtpd \
	dovecot-pigeonhole-plugin \
	dovecot-pigeonhole-plugin-ldap \
	dovecot-pop3d \
	dovecot-submissiond

# Re-enable the default Dovecot TLS configuration
RUN rm /etc/dovecot/local.conf

# Set logging to STDOUT/STDERR
RUN sed -i -e 's,#log_path = syslog,log_path = /dev/stderr,' \
           -e 's,#info_log_path =,info_log_path = /dev/stdout,' \
           -e 's,#debug_log_path =,debug_log_path = /dev/stdout,' \
	/etc/dovecot/conf.d/10-logging.conf

# Set default passdb to ldap 
RUN sed -i -e 's,!include auth-system.conf.ext,!include auth-ldap.conf.ext,' \
           -e 's,#!include auth-ldap.conf.ext,#!include auth-system.conf.ext,' \
	/etc/dovecot/conf.d/10-auth.conf

# Copy LDAP configuration
COPY scripts/* /etc/dovecot/

# Set default mail location to "/var/lib/mail"
RUN sed -i -e 's,#mail_location =,mail_location = /var/lib/mail/%n,' \
	/etc/dovecot/conf.d/10-mail.conf

# Remove left-over temporary files
RUN find /var/cache/apk /tmp -mindepth 1 -delete

#   24: LMTP
#  110: POP3 (StartTLS)
#  143: IMAP4 (StartTLS)
#  993: IMAP (SSL, deprecated)
#  995: POP3 (SSL, deprecated)
# 4190: ManageSieve (StartTLS)
EXPOSE 24 110 143 993 995 4190

VOLUME ["/mail", "/var/lib/mail"]
VOLUME ["/certs", "/etc/ssl/dovecot"]

ENTRYPOINT ["/docker-entrypoint.sh"]