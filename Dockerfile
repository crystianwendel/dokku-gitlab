FROM sameersbn/gitlab:10.5.1

ENV USERMAP_UID=998 \
    USERMAP_GID=998 \
    GITLAB_HOST="gitlab.dokku.me" \
		GITLAB_TRUSTED_PROXIES="127.0.0.1" \
		GITLAB_EMAIL="git@gitlab.dokku.me" \
		GITLAB_SIGNUP_ENABLED="false" \
		GITLAB_SSH_PORT="4444" \
		DB_ADAPTER=postgresql \
		DB_NAME=gitlabhq_production \
		DB_USER=gitlab \
		DB_PASS=66a5d4a1cda26444729645d883b238a4


EXPOSE 80
ENTRYPOINT ["/sbin/dokku-entrypoint.sh"]
CMD ["app:start"]

# Procfile interferes with Dokku
RUN rm Procfile

COPY sbin/* /sbin/

# GitLab startup time is unpredictable. Refrain from using CHECKS at the moment.
#COPY CHECKS /app/
