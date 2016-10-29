#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> 检测到空的或未初始化的MySQL在 $VOLUME_HOME"
    echo "=> 安装MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> 完成!"  
    /create_mysql_root.sh
else
    echo "=> 使用现有的MySQL数据库"
fi

exec supervisord -n
