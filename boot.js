#!/usr/bin/env zx

const LogFile = '.cache/boot.log';

within(async () => {
  await $`echo ---------------------------------------------------- >> ${LogFile}`;
  await $`date >> ${LogFile}`;

  await $`pm2 start -n dler ".config/clash/clash-linux-386" -- -f .config/clash/config.yml`;
  await $`pm2 start -n doc "pen" -- -p4000 -r repos/doc`;
  
  await $`pm2 start -n fcitx5 "fcitx5"`;

  // await cd('repos/tusk');
  // await $`pm2 start -n tusk yarn -- start`;

  await $`rsync ./pdf/ $TSS:~/ftp/pdf -zrv --delete --progress --exclude=".*" 2<&1 | tee ${LogFile}`
  await $`rsync ./pdf/ root@$BDW:~/ftp/pdf -e "ssh -p 27266" -zrv --progress --exclude=".*" 2<&1 | tee ${LogFile}`
})
