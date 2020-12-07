#!/bin/bash

set -e
set -x

host="$1"
shift
cmd="$@"

until mysql -h "$host" -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e 'select 1'; do
  >&2 echo "MySQL está indisponível - aguardando execução"
  sleep 1
done

>&2 echo "Mysql está respondendo - comando executado."
exec $cmd