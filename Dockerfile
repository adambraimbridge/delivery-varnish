FROM alpine:3.9

ENV VARNISHSRC=/usr/include/varnish VMODDIR=/usr/lib/varnish/vmods

RUN apk --update add  varnish-dev git automake autoconf libtool python3 make py-docutils curl jq && apk add --repository http://dl-cdn.alpinelinux.org/alpine/v3.9/main/ varnish~=6.2.1-r0 && ln -s /usr/bin/python3.7  /usr/bin/python && \
  cd / && \
  git clone https://github.com/varnish/varnish-modules.git && \
  cd varnish-modules && \
  git checkout  f771780801b5cf8b77954226a4f623fac759cd1e && \
  ./bootstrap && \
  ./configure && \
  make  && \
  make install && \
  cd / && \
  git clone http://git.gnu.org.ua/repo/vmod-basicauth.git && \
  cd vmod-basicauth && \
  git checkout ef9772ebab0c3aeaf6ad9a8f843fa458d0c8397c && \
  ./bootstrap && \
  ./configure && \
  make && \
  make install && \
  apk del git automake autoconf libtool python make py-docutils && \
  rm -rf /var/cache/apk/* /libvmod-vsthrottle /vmod-basicauth

COPY default.vcl /etc/varnish/default.vcl
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 80
CMD ["/start.sh"]
