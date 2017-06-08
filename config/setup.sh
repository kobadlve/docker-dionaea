#!/bin/bash

cp -f /opt/dionaea/etc/dionaea/config/dionaea.conf /opt/dionaea/etc/dionaea
cp -f /opt/dionaea/etc/dionaea/config/ftp.py /opt/dionaea/lib/dionaea/python/dionaea
cp -f /opt/dionaea/etc/dionaea/config/mssql.py /opt/dionaea/lib/dionaea/python/dionaea/mssql
cp -f /opt/dionaea/etc/dionaea/config/index.html /opt/dionaea/var/dionaea/wwwroot
