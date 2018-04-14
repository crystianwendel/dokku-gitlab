# Run GitLab as a Dokku app

## Quick start

1. Clone/fork this project.
2. Update/add settings in `dokku.env` (please refer to <https://github.com/sameersbn/docker-gitlab#available-configuration-parameters>).
3. Run:

```bash
DOKKU_HOST=dokku.me dokku apps:create gitlab
dokku postgres:create gitlab
dokku postgres:link gitlab gitlab
echo "CREATE EXTENSION pg_trgm;" | dokku postgres:connect gitlab
# pg_dump --no-owner --no-acl old_gitlab > gitlab.backup.sql
# dokku postgres:connect gitlab < gitlab.backup.sql
dokku redis:create gitlab
dokku redis:link gitlab gitlab
dokku config:set gitlab GITLAB_SECRETS_OTP_KEY_BASE="$(pwgen -s -n 64 -c 1)" GITLAB_SECRETS_DB_KEY_BASE="$(pwgen -s -n 64 -c 1)" GITLAB_SECRETS_SECRET_KEY_BASE="$(pwgen -s -n 64 -c 1)" GITLAB_SSH_PORT="4444" USERMAP_UID=998 USERMAP_GID=998 DB_ADAPTER=postgresql DB_HOST=10.11.12.13 DB_NAME=gitlabhq_production DB_USER=gitlab DB_PASS=password DATABASE_URL=postgres://gitlab:password@10.11.12.13:5432/ gitlabhq_production GITLAB_HOST="gitlab.dokku.me" GITLAB_TRUSTED_PROXIES="127.0.0.1" GITLAB_EMAIL="git@gitlab.dokku.me" GITLAB_SIGNUP_ENABLED="false" REDIS_HOST=dokku-redis-gitlab REDIS_PORT=6379
dokku config:set gitlab $(cat dokku.env)
dokku storage:mount gitlab /srv/gitlab/data:/home/git/data
dokku storage:mount gitlab /srv/gitlab/log:/var/log/gitlab
git push dokku master
```

Your new GitLab instance is now running at <https://git.dokku.me>.

## Enable SSH access

Please note that GitLab SSH server runs *inside* the Docker container. You will need to setup port forwarding on the host to connect to it from the outside network. This guide doesn't cover that scenario.

Alternatively, it is possible to setup a SSH proxy at the Dokku host, which will allow to access GitLab like this:

```bash
git clone git@git.dokku.me:group/project.git
```

To achieve that, please follow the guide from <https://github.com/sameersbn/docker-gitlab/pull/737>.

After walking through the guide, replace the docker container name in the proxy script with `gitlab.web.1`:

```bash
docker exec -i -u git gitlab.web.1 sh ...
```
