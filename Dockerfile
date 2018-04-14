FROM sameersbn/gitlab:10.6.4

ENV USERMAP_UID=998 \
	  USERMAP_GID=998 \
    GITLAB_HOST="gitlab.dokku.me" \
		GITLAB_TRUSTED_PROXIES="127.0.0.1" \
		GITLAB_EMAIL="git@gitlab.dokku.me" \
		GITLAB_SIGNUP_ENABLED="false" \
		GITLAB_SSH_PORT="4444"

EXPOSE 80
EXPOSE 4444:22
ENTRYPOINT ["/sbin/dokku-entrypoint.sh"]
CMD ["app:start"]

# Procfile interferes with Dokku
RUN rm Procfile

COPY sbin/* /sbin/

# GitLab startup time is unpredictable. Refrain from using CHECKS at the moment.
#COPY CHECKS /app/
