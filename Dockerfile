FROM alpine:latest as download
RUN apk add --no-cache curl unzip wget
RUN curl -s https://get-latest.deno.dev/pocketbase/pocketbase?no-v=true > tag.txt
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v$(cat tag.txt)/pocketbase_$(cat tag.txt)_linux_amd64.zip \
    && unzip pocketbase_$(cat tag.txt)_linux_amd64.zip \
    && chmod +x pocketbase

FROM alpine:latest
RUN apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*
COPY --from=download /pocketbase /usr/local/bin/pocketbase

# Add the bootstrap script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
