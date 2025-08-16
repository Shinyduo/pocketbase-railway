FROM alpine:latest as download
RUN apk add --no-cache curl unzip wget
RUN curl -s https://get-latest.deno.dev/pocketbase/pocketbase?no-v=true > tag.txt
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v$(cat tag.txt)/pocketbase_$(cat tag.txt)_linux_amd64.zip \
    && unzip pocketbase_$(cat tag.txt)_linux_amd64.zip \
    && chmod +x pocketbase

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=download /pocketbase /usr/local/bin/pocketbase

# (Optional) Copy your app data here if needed, e.g. COPY ./pb_migrations /data

EXPOSE 8080
# The critical fix: use $PORT for proper Railway routing
ENTRYPOINT /usr/local/bin/pocketbase serve --http=0.0.0.0:$PORT --dir=/root/pocketbase
