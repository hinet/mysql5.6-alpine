FROM alpine:3.8
LABEL maintainer="hinet <63603636@qq.com>"
# 安装开发工具包alpine-sdk
RUN apk add cmake alpine-sdk ncurses
RUN addgroup mysql
RUN adduser mysql -G mysql -s /sbin/nologin -D 
RUN mkdir -p /usr/local/mysql
RUN chown -R mysql:mysql /usr/local/mysql

RUN wget https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.40.tar.gz
RUN tar zxf mysql-5.6.40.tar.gz -C /usr/local/mysql
RUN rm -rf mysql-5.6.40.tar.gz
RUN cd /usr/local/mysql

RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
  -DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
  -DDEFAULT_CHARSET=utf8 \
  -DDEFAULT_COLLATION=utf8_general_ci \
  -DWITH_INNOBASE_STORAGE_ENGINE=1 \
  -DWITH_MYISAM_STORAGE_ENGINE=1 \
  -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
  -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
  -DMYSQL_DATADIR=/usr/local/mysql/data \
  -DMYSQL_TCP_PORT=3306 \
  -DENABLE_DOWNLOADS=1

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
RUN chmod 644 my.cnf
#建立临时文件，日志存储文件目录
RUN mkdir -p tmp logs run/mysqld
RUN scripts/mysql_install_db --user=mysql --defaults-file=/usr/local/mysql/my.cnf --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data/

