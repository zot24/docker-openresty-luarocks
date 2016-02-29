FROM zot24/openresty
MAINTAINER Israel Sotomayor <sotoisra24@gmail.com>

ENV LUAROCKS_VERSION luarocks-2.3.0

WORKDIR $TMP_DIR
RUN echo "==> Installing LuaRocks dependencies ..." \
  && apk --no-cache add --virtual build-dependencies \
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
  && echo "==> Downloading LuaRocks ..." \
  && curl -sSL http://keplerproject.github.io/luarocks/releases/$LUAROCKS_VERSION.tar.gz | tar -xz \
  && cd $TMP_DIR/$LUAROCKS_VERSION \
  && echo "==> Configuring LuaRocks ..." \
  && ./configure \
    --prefix=$OPENRESTY_PREFIX/luajit \
    --lua-suffix=jit-2.1.0-beta1 \
    --with-lua=$OPENRESTY_PREFIX/luajit \
    --with-lua-lib=$OPENRESTY_PREFIX/luajit/lib \
    --with-lua-include=$OPENRESTY_PREFIX/luajit/include/luajit-2.1 \
  && echo "==> Building LuaRocks ..." \
  && make build \
  && echo "==> Installing LuaRocks ..." \
  && make install \
  && echo "==> Cleaning up LuaRocks installation ..." \
  && rm -rf $TMP_DIR/$LUAROCKS_VERSION \
  && apk del build-dependencies \
  && rm -rf ~/.cache

RUN ln -sf $OPENRESTY_PREFIX/luajit/bin/luarocks /usr/local/bin/luarocks

RUN apk --no-cache add unzip

WORKDIR $NGINX_PREFIX
