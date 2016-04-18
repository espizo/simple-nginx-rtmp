FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /root

RUN apt-get install -q -y software-properties-common \
    && add-apt-repository ppa:mc3man/trusty-media && apt-get -q -y update \
    && apt-get install -q -y build-essential ffmpeg curl libxml2 libxslt-dev \
    && apt-get build-dep -q -y nginx \
    && apt-get -q -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN groupadd nginx \
    && useradd -m -g nginx nginx \
    && mkdir -p /www /var/log/nginx

ENV NGINX_VERSION 1.8.1
ENV NGINX_RTMP_MODULE_VERSION 1.1.7

RUN curl -L http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | tar zx
RUN curl -L https://github.com/arut/nginx-rtmp-module/archive/v$NGINX_RTMP_MODULE_VERSION.tar.gz | tar zx

RUN cd nginx-$NGINX_VERSION \
    && ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --with-http_xslt_module \
        --add-module=/root/nginx-rtmp-module-$NGINX_RTMP_MODULE_VERSION \
    && make install

RUN cp nginx-rtmp-module-$NGINX_RTMP_MODULE_VERSION/stat.xsl /www/info.xsl

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/nginx.conf
COPY www/ /www/

EXPOSE 80 1935

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]
