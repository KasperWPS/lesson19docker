FROM alpine:latest
RUN apk add --no-cache nginx
COPY root /
EXPOSE 80/tcp
CMD /usr/sbin/nginx -g "daemon off;"

