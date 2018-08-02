FROM dezinger/ubuntu-14:latest

MAINTAINER dezinger@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV DOCUMENT_ROOT html

COPY files/ /

RUN \
# install Nginx.
    add-apt-repository -y ppa:nginx/stable && \
    apt-get update && \
    apt-get install -y nginx && \
# configure 
    sed -i -r -e '/^user www-data;/d' /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    sed -i -e '/sendfile on;/a\        client_max_body_size 0\;' /etc/nginx/nginx.conf && \
    sed -i -e 's/gzip on/#gzip on/' /etc/nginx/nginx.conf && \
    sed -i -e 's/gzip_disable/#gzip_disable/' /etc/nginx/nginx.conf && \
# remove default configs  
    rm /etc/nginx/sites-available/* /etc/nginx/sites-enabled/default && \
# make dir and rights    
    mkdir -p /var/www/html && \
    chmod 777 /var/www/html /var/lib/nginx && \
    chmod -R 777 /var/log/nginx && \
    chmod -R 755 /hooks /init && \
    chmod 755 /var/www && \
    chmod -R 666 /etc/nginx/sites-enabled/* /etc/nginx/conf.d/* && \
    
    mkdir -p /var/cache/nginx/proxy && \
    chown -R www-data:www-data /var/lib/nginx /var/cache/nginx/proxy

EXPOSE 80