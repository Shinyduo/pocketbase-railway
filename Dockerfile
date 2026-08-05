FROM alpine:3.22 AS download
ARG PB_VERSION=0.39.10
RUN apk add --no-cache unzip wget
RUN wget -q -O pocketbase.zip https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip \
    && unzip pocketbase.zip pocketbase \
    && chmod +x pocketbase

FROM alpine:3.22
RUN apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*
COPY --from=download /pocketbase /usr/local/bin/pocketbase

# Add the bootstrap script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
