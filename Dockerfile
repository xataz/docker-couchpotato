FROM xataz/alpine:3.6

ENV WEBROOT="" \
    UID=991 \
    GID=991

LABEL description="Couchpotato based on alpine" \
      tags="latest" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="2017062601"

RUN export BUILD_DEPS="py2-pip \
                    build-base \
                    libxml2-dev \
                    python2-dev \
                    libxslt-dev \
                    libffi-dev \
                    openssl-dev" \
    && apk add -U python2 \
                libxml2 \
                libxslt \
                libffi \
                libssl1.0 \
                git \
                su-exec \
                s6 \
                ${BUILD_DEPS} \
    && git clone https://github.com/CouchPotato/CouchPotatoServer \
    && cd /CouchPotatoServer \
    && pip install lxml pyopenssl \
    && apk del ${BUILD_DEPS} \
    && rm -fr /var/cache/apk/* ~/.pip/cache/*

VOLUME ["/config"]
EXPOSE 5050
COPY rootfs /
RUN chmod +x /usr/local/bin/startup /etc/s6.d/*/*

ENTRYPOINT ["/usr/local/bin/startup"]
CMD ["/bin/s6-svscan", "/etc/s6.d"]
