FROM registry:2.7

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
