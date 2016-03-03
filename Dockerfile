FROM zot24/openresty
MAINTAINER Israel Sotomayor <sotoisra24@gmail.com>

ENV LUAROCKS_SRC_SHA1=5f1e1658ef8c7c9710fbc751cad79eb69ae2a891 \
    LUAROCKS_VERSION=2.3.0

RUN set -ex \
  && apk --no-cache add --virtual .build-dependencies \
    curl \
    make \
    musl-dev \
    gcc \
    ncurses-dev \
    openssl-dev \
    pcre-dev \
    perl \
    readline-dev \
    zlib-dev \
  \
  && curl -sSL http://keplerproject.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz -o /tmp/luarocks.tar.gz \
  \
  && cd /tmp \
  && echo "${LUAROCKS_SRC_SHA1} *luarocks.tar.gz" | sha1sum -c - \
  && tar -xzf luarocks.tar.gz \
  \
  && cd luarocks-* \
  && ./configure \
    --prefix=${OPENRESTY_PREFIX}/luajit \
    --lua-suffix=${LUA_SUFFIX} \
    --with-lua=${OPENRESTY_PREFIX}/luajit \
    --with-lua-lib=${OPENRESTY_PREFIX}/luajit/lib \
    --with-lua-include=${OPENRESTY_PREFIX}/luajit/include/luajit-${LUAJIT_VERSION} \
  && make build \
  && make install \
  \
  && rm -rf /tmp/luarocks-* \
  && apk del .build-dependencies \
  && rm -rf ~/.cache/luarocks

RUN ln -sf ${OPENRESTY_PREFIX}/luajit/bin/luarocks /usr/local/bin/luarocks

RUN apk --no-cache add unzip

WORKDIR $NGINX_PREFIX
