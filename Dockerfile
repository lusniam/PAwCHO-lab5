
FROM alpine AS builder

RUN apk add --no-cache bash

RUN mkdir -p /app
RUN echo 'echo "\
<html><body>\
<h1>Aplikacja PAwChO</h1>\
<h2>Maciej Lusnia</h2>\
<p>Server IP: $(hostname -i)</p>\
<p>Hostname: $(hostname)</p>\
<p>Version: ${VERSION}</p>\
</body></html>"\
 > /usr/share/nginx/html/index.html' > /app/index.sh

FROM nginx:alpine

ARG VERSION="1.0.0"

RUN mkdir -p /app
COPY --from=builder /app/index.sh /app/index.sh
RUN chmod +x /app/index.sh && /app/index.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]