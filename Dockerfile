FROM alpine:3.8
LABEL maintainer="hinet <63603636@qq.com>"

RUN addgroup mysql
RUN adduser mysql -G mysql -D
RUN mkdir -p /usr/local/mysql
RUN chown -R mysql:mysql /usr/local/mysql

RUN wget https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz
RUN tar zxf mysql-5.6.40-linux-glibc2.12-x86_64.tar.gz
RUN cp -rf /mysql-5.6.40-linux-glibc2.12-x86_64/* /usr/local/mysql/
RUN rm -rf /mysql*

RUN cd /usr/local/mysql

RUN echo -e "[client]\ndefault-character-set=utf8\n" \
"socket=/usr/local/mysql/tmp/mysql.sock\n\n" \
"[mysql]\ndefault-character-set=utf8\n" \
"[mysqld]\nsocket=/usr/local/mysql/tmp/mysql.sock\n" \
"tmpdir=/usr/local/mysql/tmp/\n" \
"basedir=/usr/local/mysql\n" \
"datadir=/usr/local/mysql/data\n" \
"symbolic-links=0\n" \
"character_set_server=utf8\n" \
"[mysqld_safe]\n" \
"default-character-set=utf8\n" \
"log-error=/usr/local/mysql/logs/mysqld.log\n" \
"pid-file=/usr/local/mysql/run/mysqld/mysqld.pid\n">my.cnf

