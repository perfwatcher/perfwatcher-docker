from phusion/baseimage
maintainer Cyril FERAUDET, cyril@feraudet.com

ENV HOME /root
#ENV http_proxy http://10.0.0.1:8080

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

ADD id_dsa.pub /tmp/your_key
RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key

ADD etc_mtab /etc/mtab
run apt-get update
run apt-get install -y build-essential wget zlib1g-dev librrd-dev rrdtool \
 libdbi0-dev libapache2-mod-php5

# json-c installation
RUN wget http://s3.amazonaws.com/json-c_releases/releases/json-c-0.10.tar.gz
RUN tar xzf json-c-0.10.tar.gz && cd json-c-0.10 && \
 ./configure --prefix=/usr && make -j && make install && \
 cp json_object_iterator.h /usr/include/json && cd .. && \
 rm -r json-c-0.10 json-c-0.10.tar.gz

# libmicrohttpd installation
RUN wget http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.22.tar.gz
RUN tar xzf libmicrohttpd-0.9.22.tar.gz && cd libmicrohttpd-0.9.22 && \
 ./configure --prefix=/usr && make -j &&  make install && cd .. && \
 rm -r libmicrohttpd-0.9.22 libmicrohttpd-0.9.22.tar.gz

# collectd-pw installation
RUN wget http://perfwatcher.free.fr/download/collectd/collectd-5.4.0.20140219.tar.gz 
RUN tar xzf collectd-5.4.0.20140219.tar.gz
RUN cd collectd-5.4.0.20140219 && CFLAGS=" -Wno-error=unused-but-set-variable -Wno-error=deprecated-declarations " ./configure --enable-top \ 
 --enable-cpu --enable-rrdtool --enable-jsonrpc \
 --enable-notify_file --enable-basic_aggregator \
 --enable-write_top --prefix=/usr && make -j && make install && \
 cp src/types-perfwatcher.db /etc

RUN mkdir /etc/collectd/ && a2enmod php5 && a2enmod proxy && a2enmod proxy_http
ADD collectd.conf /etc/collectd/collectd.conf

# php & mysql installation
RUN apt-get install -y php5-gd php5-mysql php5-curl mysql-server mysql-client php-pear php-mdb2-driver-mysql

# perfwatcher installation
RUN wget http://perfwatcher.free.fr/download/perfwatcher/perfwatcher-2.1-20140326.tar.gz
RUN tar xzf perfwatcher-2.1-20140326.tar.gz && rm perfwatcher-2.1-20140326.tar.gz && \
mv perfwatcher-2.1-20140326 /var/www/html/perfwatcher
#RUN apt-get install -y git
#RUN git config --global http.proxy $http_proxy ; git clone -b 'release/1.2' https://github.com/perfwatcher/perfwatcher.git /var/www/html/perfwatcher

RUN mkdir /var/www/html/perfwatcher/logs && chown www-data:www-data /var/www/html/perfwatcher/logs /var/www/html/perfwatcher/etc
ADD config.php /var/www/html/perfwatcher/etc/config.php

RUN mkdir /etc/service/collectd
ADD collectd.sh /etc/service/collectd/run
RUN mkdir /etc/service/apache2
ADD apache2.sh /etc/service/apache2/run
RUN mkdir /etc/service/mysql
ADD mysql.sh /etc/service/mysql/run

CMD ["/sbin/my_init"]

ADD cron /etc/cron.d/perfwatcher

EXPOSE 80
EXPOSE 25826

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
