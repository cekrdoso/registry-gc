FROM registry:2.7

COPY docker-entrypoint.sh /entrypoint.sh

COPY exec-garbage-collect.sh /exec-garbage-collect.sh 

RUN apk --no-cache add tzdata \
  && chmod +x /entrypoint.sh /exec-garbage-collect.sh 
