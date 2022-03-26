#!/bin/bash

# script on system start up

logfile=.cache/boot.log

pm2 start -n dler "./.config/clash/clash-linux-386" -- -f ./.config/clash/.dler.yml;
pm2 start -n doc "pen" -- -p4000 -r ~/repos/doc;
pm2 start -n pdf "pen" -- -p5000 -r ~/pdf -t pdf -t md;

pushd ./repos/tusk/
pm2 start -n tusk yarn -- start
popd

date >> $logfile;
rsync ./pdf/ $TSS:~/ftp/pdf -zrv --delete --progress --exclude=".*" >> $logfile 2<&1;

