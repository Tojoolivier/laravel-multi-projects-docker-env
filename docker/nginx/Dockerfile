FROM nginx:alpine

RUN apk add --no-cache bash inotify-tools

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]