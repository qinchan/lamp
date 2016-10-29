#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> 等待确认MySQL服务启动"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MYSQL_PASS} ] && echo "预设" || echo "随机" )
echo "=> 使用${_word}密码创建MySQL管理用户"

mysql -uroot -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION"


echo "=> 完成!"

echo "========================================================================"
echo "				您现在可以使用连接到此MySQL服务器:"
echo ""
echo "    			mysql -u$MYSQL_USER -p$PASS -h<host> -P<port>"
echo ""
echo "				请记住尽快更改上述密码!"
echo "				MySQL用户'root'没有密码，只允许本地连接"
echo "========================================================================"

mysqladmin -uroot shutdown
