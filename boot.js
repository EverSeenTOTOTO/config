#!/usr/bin/env zx

const LogFile = '.cache/boot.log';

within(async () => {
  await $`echo ---------------------------------------------------- >> ${LogFile}`;
  await $`date >> ${LogFile}`;

  await $`pm2 start -n clash ".cfw/cfw"`;
  await $`pm2 start -n doc "pen" -- -p4000 -r repos/docs`;

  await $`pm2 start -n fcitx5 "fcitx5"`;
  await $`pm2 start -n hidden "v2ray" -- run --config .config/v2ray/config-hidden.json`;

  await $`rsync ./pdf/ $TSS:~/ftp/pdf -zrv --progress --exclude=".*" 2<&1 | tee ${LogFile}`;
})
