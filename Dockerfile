FROM crashvb/cron:202404131826@sha256:663a13bc37ef2db8d336eabe3b88734d65ac3a5674c539eb116ec18ba4642cc6
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:663a13bc37ef2db8d336eabe3b88734d65ac3a5674c539eb116ec18ba4642cc6" \
	org.opencontainers.image.base.name="crashvb/supervisord:202404131826" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing minecraft bedrock." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/minecraft-bedrock-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/minecraft-bedrock" \
	org.opencontainers.image.url="https://github.com/crashvb/minecraft-bedrock-docker"

# Install packages, download files ...
RUN docker-apt jq unzip

# Configure: minecraft
ENV \
	CRONTAB_ENVSUBST_MINECRAFT="\${MINECRAFT_REBOOT_SCHEDULE} root exec /bin/bash -c \"echo 'Rebooting server...'; /usr/bin/pkill --full --signal=QUIT /usr/bin/supervisord\"" \
	MINECRAFT_ALLOW_LIST=true \
	MINECRAFT_CONFIG=/etc/minecraft \
	MINECRAFT_DOWNLOAD_URL=https://net-secondary.web.minecraft-services.net/api/v1.0/download/links \
	MINECRAFT_HOME=/var/lib/minecraft \
	MINECRAFT_REBOOT_SCHEDULE="0 4 * * *" \
	MINECRAFT_SHARE=/usr/local/share/minecraft
COPY minecraft-update.configs ${MINECRAFT_SHARE}/
COPY minecraft-update minecraft-upgrade /usr/local/bin/
RUN groupadd minecraft && \
	useradd --create-home --gid=minecraft --home-dir="${MINECRAFT_HOME}" --shell=/usr/sbin/nologin minecraft && \
	install --directory --group=minecraft --owner=minecraft "${MINECRAFT_CONFIG}" "${MINECRAFT_SHARE}/embedded" && \
	minecraft-update

# Configure: supervisor
COPY supervisord.minecraft.conf /etc/supervisor/conf.d/minecraft.conf

# Configure: entrypoint
COPY entrypoint.minecraft /etc/entrypoint.d/minecraft

# Configure: healthcheck
COPY healthcheck.minecraft /etc/healthcheck.d/minecraft

EXPOSE 19132/udp 19133/udp

VOLUME ${MINECRAFT_CONFIG} ${MINECRAFT_HOME}
