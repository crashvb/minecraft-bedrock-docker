FROM crashvb/supervisord:202201080446@sha256:8fe6a411bea68df4b4c6c611db63c22f32c4a455254fa322f381d72340ea7226
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:8fe6a411bea68df4b4c6c611db63c22f32c4a455254fa322f381d72340ea7226" \
	org.opencontainers.image.base.name="crashvb/supervisord:202201080446" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing minecraft bedrock." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/minecraft-bedrock-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/minecraft-bedrock" \
	org.opencontainers.image.url="https://github.com/crashvb/minecraft-bedrock-docker"

# Install packages, download files ...
RUN docker-apt cron jq unzip

# Configure: minecraft
ENV \
	MINECRAFT_ALLOW_LIST=true \
	MINECRAFT_CONFIG=/etc/minecraft \
	MINECRAFT_DOWNLOAD_URL=https://www.minecraft.net/en-us/download/server/bedrock \
	MINECRAFT_HOME=/var/lib/minecraft \
	MINECRAFT_REBOOT_SCHEDULE="0 4 * * *" \
	MINECRAFT_SHARE=/usr/local/share/minecraft
COPY cron.* minecraft-download.configs ${MINECRAFT_SHARE}/
COPY minecraft-download /usr/local/bin/
RUN groupadd minecraft && \
	useradd --create-home --gid=minecraft --home-dir="${MINECRAFT_HOME}" --shell=/usr/bin/nologin minecraft && \
	install --directory --group=minecraft --owner=minecraft "${MINECRAFT_CONFIG}" "${MINECRAFT_SHARE}/embedded" && \
	minecraft-download && \
	rm --force /etc/cron.*/*

# Configure: supervisor
COPY supervisord.cron.conf /etc/supervisor/conf.d/cron.conf
COPY supervisord.minecraft.conf /etc/supervisor/conf.d/minecraft.conf

# Configure: entrypoint
COPY entrypoint.minecraft /etc/entrypoint.d/minecraft

# Configure: healthcheck
COPY healthcheck.cron /etc/healthcheck.d/cron
COPY healthcheck.minecraft /etc/healthcheck.d/minecraft

EXPOSE 19132/udp 19133/udp

VOLUME ${MINECRAFT_CONFIG} ${MINECRAFT_HOME}
